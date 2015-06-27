<!doctype html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <title>course_like test</title>

    </head>
    <body>

        <form action="<?php echo base_url('catalog/course_like'); ?>" id="searchForm" method="post">
            <input type="text" name="course_id" placeholder="course_id...">
            <input type="text" name="user_id" placeholder="user_id...">
  <input type="submit" value="submit">

        </form>
        <!-- the result of the search will be rendered inside this div -->
        <div id="result"></div>


    </body>
</html>