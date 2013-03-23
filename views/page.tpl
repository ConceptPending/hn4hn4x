<div class="row">
    %counteri = 1
    %for entry in entries:
    %if entry[6] != 1:
    %vote_button = """<a class="vote" href="/vote/%s">&#x25B2;</a>""" % entry[0]
    %else:
    %vote_button = """&nbsp;"""
    %end
    <div class="span10">
        <h2>{{!vote_button}}{{counteri}}. <a href="{{entry[2]}}">{{entry[1]}}</a></h2>
        <div class="listing">
            <p><span class="author">posted by {{entry[4]}}</span><span class="date"><em>{{entry[5]}} points</em></span></p>
        </div>
    </div>
    %counteri += 1
    %if not counteri % 1: # You should change the number here to the number of items you want per row. You also need to change the "span" class above if you do so.
    </div>
    <div class="row">
    %end
    %end
</div>
%if user_info == None:
%   auth_html = """<a href="/signup">Sign Up!</a>"""
%else:
%   auth_html = """<a href="/u/%s">%s</a>""" % (user_info['user_id'],user_info['user_name'])
%end
%rebase base_template title='Hacker News for "Hacker News for X"', h1Title='Hacker News for "Hacker News for X"', description='Hacker News for "Hacker News for X"', auth_html=auth_html
