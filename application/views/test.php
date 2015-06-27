<!doctype html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <title>Signin test</title>

    </head>
    <body>

        <form action="<?php echo base_url('catalog/signin'); ?>" id="searchForm" method="post">
            Profile photo: <input type="text" name="profile_photo_url" placeholder="image..."> <br/>
            UUID: <input type="text" name="uuid" placeholder="uuid..."><br/>
            Full Name: <input type="text" name="full_name" placeholder="name..."><br/>
            Email: <input type="text" name="email" placeholder="email..."><br/>
            twitter handle: <input type="text" name="twitter_handle" placeholder="twitter_handle..."><br/>
            registration date: <input type="text" name="registration_date" placeholder="registration_date"><br/>
            <input type="submit" value="submit">
        </form>
        <!-- the result of the search will be rendered inside this div -->
        <div id="result"></div>


    </body>
</html>