<div class="row">
    <div class="span1"></div>
    <div class="span5">
        <h2>Submit a Link</h2>
        <div class="listing">
            <form action="/submit" method="post">
                <label for="title">Title:</label><br>
                <input type="text" name="title" id="title"><br>
                <label for="link">Link:</label><br>
                <input type="text" name="link" id="link"><br>
                <input class="btn" type="submit" name="submit" id="submit" value="submit">
            </form>
        </div>
    </div>
</div>
%   auth_html = """<a href="/u/%s">%s</a>""" % (user_info['user_id'], user_info['user_name'])
%rebase base_template title='Hacker News for "Hacker News for X"', h1Title='Hacker News for "Hacker News for X"', description='Hacker News for "Hacker News for X"', auth_html=auth_html
