from bottle import route, run, debug, template, static_file, post, request, app, get, redirect
from beaker.middleware import SessionMiddleware
import os
import psycopg2
import smtplib
import string
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
import random

def random_string(length):
    pool = string.letters + string.digits
    return ''.join(random.choice(pool) for i in xrange(length))

@route('/')
def index():
    session = authenticate()
    if not session.has_key('user_name'):
        user_info = None
        session['user_id'] = 0
    else:
        user_info = session
    cur = connect_db()
    cur.execute("""
        SELECT 
            hnc_entries.thread_id,
            thread_title,
            thread_link,
            hnc_entries.user_id,
            user_name,
            thread_upvotes,
            voted_flag
        FROM hnc_entries
        LEFT JOIN (SELECT thread_id, COUNT(*) AS thread_upvotes FROM hnc_votes GROUP BY thread_id) AS upvotes on hnc_entries.thread_id = upvotes.thread_id
        LEFT JOIN (SELECT thread_id, 1 AS voted_flag FROM hnc_votes WHERE user_id = %s GROUP BY thread_id) AS voted_flags on hnc_entries.thread_id = voted_flags.thread_id
        LEFT JOIN hnc_users on hnc_entries.user_id = hnc_users.user_id
        LIMIT 35;
    """, (session['user_id']))
    entries = cur.fetchall()
    return template("page", entries=entries, user_info=user_info)

@route('/u/<user_id>')
@route('/u/<user_id/')
def view_user(user_id):
    session = authenticate()
    cur = connect_db()
    if session['user_id'] == user_id:
        return template("own_page", user_name=session['user_name'], user_email=user_email)
    else:
        redirect('/')

@route('/existing')
@route('/existing/')
def existing():
    return template("existing", user_dupe=None)

@post('/existing')
def resend_auth_link():
    user_email = request.forms.get('user_email')
    user_auth = random_string(32)
    cur = connect_db()
    cur.execute("UPDATE hnc_users SET user_auth = %s WHERE user_email = %s RETURNING user_id;", (user_auth, user_email))
    send_email('hn4hn4x@gmail.com', user_email, 'Log-in for Hacker News for "Hacker News for X"', gen_welcome_email(user_name, user_auth))

@post('/update')
@post('/update/')
def existing_action():
    session = authenticate()
    cur = connect_db()
    if session.has_key('user_name'):
        cur.execute("""
            UPDATE hnc_users SET user_email = %s WHERE user_id = %s
        """, request.forms.get('user_email'), session['user_id'])
    route('/u/%s' % session['user_id'])

@route('/login/<user_auth>')
@route('/login/<user_auth>/')
def auth_user(user_auth):
    session = authenticate()
    cur = connect_db()
    cur.execute("""
        SELECT user_id, user_name, user_email FROM hnc_users WHERE user_auth = %s
    """, (user_auth,))
    results = cur.fetchone()
    session['user_id'] = results[0]
    session['user_name'] = results[1]
    session['user_email'] = results[2]
    redirect('/')

@route('/submit')
@route('/submit/')
def submit():
    session = authenticate()
    if not session.has_key('user_name'):
        redirect('/signup')
    else:
        user_info = session
    return template("submit", user_info=user_info)

@post('/submit')
def submit_action():
    session = authenticate()
    title = request.forms.get('title')
    link = request.forms.get('link')
    cur = connect_db()
    cur.execute("""
        INSERT INTO hnc_entries (thread_title, thread_link, user_id) VALUES (%s, %s, %s) RETURNING thread_id;
    """, (title, link, session['user_id']))
    cur.execute("""
        INSERT INTO hnc_votes (thread_id, user_id) VALUES (%s, %s);
    """, (cur.fetchone()[0], session['user_id']))
    redirect('/')

@route('/signup', method='GET')
@route('/signup/', method='GET')
def signup():
    return template("signup", user_dupe=None)

@post('/signup')
@post('/signup/')
def signup_action():
    session = authenticate()
    user_name = request.forms.get('user_name')
    user_email = request.forms.get('user_email')
    user_auth = random_string(32)
    cur = connect_db()
    cur.execute("""
        SELECT * FROM hnc_users WHERE user_name = %s or user_email = %s;
    """, (user_name, user_email))
    if cur.fetchone() is not None:
        return template('signup', user_dupe=True)
    cur.execute("""
        INSERT INTO hnc_users (user_name, user_email, user_auth) VALUES (%s, %s, %s) RETURNING user_id;
    """, (user_name, user_email, user_auth))
    user_id = cur.fetchone()[0]
    session['user_id'] = user_id
    session['user_name'] = user_name
    session['user_email'] = user_email
    send_email('hn4hn4x@gmail.com', user_email, 'Welcome to Hacker News for "Hacker News for X"', gen_welcome_email(user_name, user_auth))
    redirect('/')

def gen_welcome_email(user_name, user_auth):
    auth_url = "hn4hn4x.herokuapp.com/login/%s" % user_auth
    msg = """
        <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
            <html xmlns="http://www.w3.org/1999/xhtml">
            <head>
            <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
            <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
            <title>Hacker News for "Hacker News for X" Auth Link</title>
            </head>
            <body>
                <h1>Hello %s,</h1>
                <p>
                    You (or someone using your email address) have made an account at Hacker News for "Hacker News of X".
                </p>
                <p>
                    We don't use passwords to authenticate, but unique authentication URLs.
                </p>
                <p>
                    To log in at any time, just follow this link <a href="%s">%s</a>
                </p>
            </body>
            </html>
    """ % (user_name, auth_url, auth_url)
    return msg

####################
#  Define Session  #
####################
session_opts = {
    'session.type': 'memory',
    'session.url': 'localhost',
    'session.cookie_expires': (3600 * 24 * 31),
    'session.auto': True
}
app = SessionMiddleware(app(), session_opts)

################################
#  Define ancillary functions  #
################################
def send_email(fromaddr, toaddrs, subject, htmlmsg):
    # The actual mail send
    msg = MIMEMultipart('alternative')
    msg['Subject'] = subject
    msg['From'] = fromaddr
    msg['To'] = toaddrs
    part1 = MIMEText(htmlmsg, 'html')
    msg.attach(part1)
    server = smtplib.SMTP('smtp.gmail.com:587')  
    server.starttls()  
    server.login(os.environ['gmail_user'], os.environ['gmail_password'])  
    server.sendmail(fromaddr, toaddrs, msg.as_string())
    server.quit()

def authenticate():
    session = request.environ['beaker.session']
    return session

def logout():
    session = request.environ['beaker.session']
    session.delete()
    
def connect_db(host=os.environ['dbhost'], dbname=os.environ['dbname'], user=os.environ['dbuser'], password=os.environ['dbpassword'], sslmode='require'):
    conn_string = "host='%s' dbname='%s' user='%s' password='%s'" % (host, dbname, user, password)
    conn = psycopg2.connect(conn_string)
    conn.set_isolation_level(0)
    cur = conn.cursor()
    return cur

debug(False)
run(app=app, host="0.0.0.0", port=int(os.environ.get("PORT", 5000)))
