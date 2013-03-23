<div class="row">
    %counteri = 1
    %for entry in entries:
    <div class="span1"></div>
    <div class="span10">
        <h2>&#x25B2;{{counteri}}. <a href="{{entry[2]}}">{{entry[1]}}</a></h2>
        <div class="listing">
            <p><span class="author">posted by <a href="/u/{{entry[3]}}">{{entry[4]}}</a></span><span class="date"><em>{{entry[5]}} points</em></span></p>
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
%   auth_html = """<a href="/user/{{user_info['user_id']}}">%s</a>""" % user_info['user_name']
%end
%rebase base_template title='Hacker News for "Hacker News for X"', h1Title='Hacker News for "Hacker News for X"', description='Hacker News for "Hacker News for X"', auth_html=auth_html
