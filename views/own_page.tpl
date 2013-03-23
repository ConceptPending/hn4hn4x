<div class="row">
    <div class="span1"></div>
    <div class="span5">
        <h2>Account Info for {{user_name}}:</h2>
        <div class="listing">
        <br>
            <form action="/update" method="post">
                <label for="user_email">Change Email Address:</label><br>
                <input type="text" name="user_email" id="user_email" value="{{user_email}}"><br>
                <input class="btn" type="submit" name="submit" id="submit" value="submit">
            </form>
        </div>
    </div>
</div>
%auth_html = """<a href="/u/%s">%s</a>""" % (user_id,user_name)
%rebase base_template title='Hacker News for "Hacker News for X"', h1Title='Hacker News for "Hacker News for X"', description='Hacker News for "Hacker News for X"', auth_html=auth_html
