<div class="row">
    <div class="span1"></div>
    <div class="span5">
        <h2>Sign Up</h2>
        <div class="listing">
        <br>
        %if user_dupe != None:
            <span class="error">Oh No! Someone has beat you to that username or email!</span>
        %end
            <form action="/signup" method="post">
                <label for="user_name">Enter your preferred username:</label><br>
                <input type="text" name="user_name" id="user_name"><br>
                <label for="user_email">Enter your email address (this is how we authenticate you):</label><br>
                <input type="text" name="user_email" id="user_email"><br>
                <input class="btn" type="submit" name="submit" id="submit" value="submit">
            </form>
            <br><a href="/existing">Already have an account?</a>
        </div>
    </div>
</div>
%auth_html = ""
%rebase base_template title='Hacker News for "Hacker News for X"', h1Title='Hacker News for "Hacker News for X"', description='Hacker News for "Hacker News for X"', auth_html=auth_html
