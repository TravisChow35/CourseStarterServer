<!doctype html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <title>Signin test</title>

    </head>
    <body>

        <form action="<?php echo base_url('catalog/add_course'); ?>" id="searchForm" method="post">
            course_name: <input type="text" name="course_name" placeholder="course_name"> <br/>
            image_url: <input type="text" name="image_url" placeholder="image_url"><br/>
            description: <input type="text" name="description" placeholder="description"><br/>
            amount: <input type="text" name="amount" placeholder="amount"><br/>
            created_by: <input type="text" name="created_by" placeholder="created_by"><br/>
            sort_order: <input type="text" name="sort_order" placeholder="sort_order"><br/>
            course_type: <input type="text" name="course_type" placeholder="course_type"><br/>

            <input type="submit" value="submit">
        </form>
        <!-- the result of the search will be rendered inside this div -->
        <div id="result"></div>


    </body>
</html>