<?php

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

class catalog extends CI_Controller {

    public function index() {
        echo 'HELP: This is course starter json api.<br>';
        echo "signin(Type: post; Params: uuid, full_name,twitter_handle,profile_photo_url,registration_date,email)<br>";
        echo "add_course(Type: post; Params: course_name, image_url,description,amount,created_by,sort_order,course_type)<br>";
        echo "connect(Type: get )<br>";
        echo "courses(Type: get)<br>";
        echo "profiles(Type: get)<br>";
        echo "course_like(Type: post; params: course_id, user_id)<br><br><br>";

        echo "http://secret-wildwood-3498.herokuapp.com/catalog/courses?user_id <br>";
        echo "http://secret-wildwood-3498.herokuapp.com/catalog/profiles <br>";
        echo "http://secret-wildwood-3498.herokuapp.com/catalog/add_course <br>";
        echo "<h2> For test </h2><br>";
        echo "http://secret-wildwood-3498.herokuapp.com/catalog/test_signin <br>";
        echo "http://secret-wildwood-3498.herokuapp.com/catalog/test_likes <br>";
        echo "http://secret-wildwood-3498.herokuapp.com/catalog/test_course <br>";
    }

    public function connect() {

        $this->index();
    }

    public function signin() {

        $signin['status'] = '0';
        if (!empty($_POST)) {
            if (!isset($_POST['twitter_handle']) || strlen($_POST['twitter_handle']) < 5) {
                $signin['error'][] = 'twitter_handle is invalid.';
            } else {
                $profile_data = $this->profiles_model->get_profiles($_POST['twitter_handle']);
                if ($profile_data) {
                    $signin['profile'] = $profile_data[0];
                    $signin['status'] = '1';
			 
                    $profile_data[0]['uuid'] = $_POST['uuid'];
                    $profile_data[0]['full_name'] = $_POST['full_name'];
                    $profile_data[0]['twitter_handle'] = $_POST['twitter_handle'];
                    $profile_data[0]['profile_photo_url'] = $_POST['profile_photo_url'];
                    //$_data['registration_date'] = $reg_date;
					if (!isset($_POST['email'])) {
							$profile_data[0]['email']  = '';
						}
						else{
                    $profile_data[0]['email'] = $_POST['email'];}
                    $this->profiles_model->update($profile_data[0], array('id' => $profile_data[0]['id']));

					$signin['profile'] = $profile_data[0];
					$signin['status'] = '1';
                    echo json_encode($signin);
                    return;
                }
            }
            if (!isset($_POST['uuid'])) {
                $signin['error'][] = 'uuid is not available.';
            }
            if (!isset($_POST['full_name']) || strlen($_POST['full_name']) < 5) {
                $signin['error'][] = 'full_name is invalid.';
            }
            if (!isset($_POST['profile_photo_url']) || strlen($_POST['profile_photo_url']) < 5) {
                $signin['error'][] = 'profile_photo_url is invalid.';
            }
            if (!isset($signin['error'])) {
                $reg_date = date("Y-m-d", strtotime($_POST['registration_date']));
                $_data['uuid'] = $_POST['uuid'];
                $_data['full_name'] = $_POST['full_name'];
                $_data['twitter_handle'] = $_POST['twitter_handle'];
                $_data['profile_photo_url'] = $_POST['profile_photo_url'];
                $_data['registration_date'] = $reg_date;
                $_data['email'] = $_POST['email'];

                $this->profiles_model->save($_data);
                $profile_data = $this->profiles_model->get_profiles($_POST['twitter_handle']);
                $signin['profile'] = $profile_data[0];
                $signin['status'] = '1';
            } else {

                $signin['result'] = 'Invalid Parameters.';
            }
        }
        echo json_encode($signin);
    }

    public function add_course() {

        $signin['status'] = '0';
        if (!empty($_POST)) {

            if (!isset($_POST['course_name'])) {
                //     $signin['error'][] = 'course_name is not available.';
            }
            if (!isset($_POST['description']) || strlen($_POST['description']) < 5) {
                $signin['error'][] = 'description is invalid.';
            }
            if (!isset($_POST['image_url']) || strlen($_POST['image_url']) < 5) {
                $signin['error'][] = 'image_url is invalid.';
            }
            if (!isset($_POST['created_by']) || !is_numeric($_POST['created_by'])) {
                $signin['error'][] = 'created_by is invalid.';
            }
            if (!isset($_POST['amount']) || !is_numeric($_POST['amount'])) {
                $signin['error'][] = 'amount is invalid.';
            }
            if (!isset($_POST['course_type'])) {
                $signin['error'][] = 'course_type is invalid.';
            }
            if (!isset($signin['error'])) {

                $_data['description'] = $_POST['description'];
                if (isset($_POST['course_name'])) {
                    $_data['course_name'] = $_POST['course_name'];
                }
                $_data['image_url'] = $_POST['image_url'];
                //  $_data['sort_order'] = $_POST['sort_order'];
                $_data['created_by'] = $_POST['created_by'];
                $_data['amount'] = $_POST['amount'];
                $_data['course_type'] = $_POST['course_type'];


                $id = $this->courses_model->save($_data);
                $course_data = $this->courses_model->get_courses($id);
                $signin['course'] = $course_data[0];
                $signin['status'] = '1';
            } else {

                $signin['result'] = 'Invalid Parameters.';
            }
        }
        echo json_encode($signin);
    }

    public function test_signin() {
        $this->load->view('test');
    }

    public function test_course() {
        $this->load->view('add_course');
    }

    public function test_likes() {
        $this->load->view('test_likes');
    }

    public function courses() {
        $courses['status'] = 0;
        $courses_data = $this->courses_model->get_courses();
        if ($courses_data) {
            $courses['courses'] = $courses_data;
            $courses['status'] = 1;
            $courses['message'] = 'valid data';
        } else {
            $courses['message'] = 'No data found';
        }


        echo json_encode($courses);
    }

    public function profiles() {
        $profiles['status'] = 0;
        $profiles_data = $this->profiles_model->get_profiles();
        if ($profiles_data) {
            $profiles['profiles'] = $profiles_data;
            $profiles['status'] = 1;
            $profiles['message'] = 'valid data';
        } else {
            $profiles['message'] = 'No data found';
        }


        echo json_encode($profiles);
    }

    public function course_like() {
        $course_like['result'] = 'none';
        $course_like['status'] = '0';
        if (!empty($_POST)) {
            if (isset($_POST['course_id']) && isset($_POST['user_id'])) {
                $_data['course_id'] = $_POST['course_id'];
                $_data['user_id'] = $_POST['user_id'];

                $course = $this->course_likes_model->find('courses', '*', array('id' => $_data['course_id']));
                $profile = $this->course_likes_model->find('profiles', '*', array('id' => $_data['user_id']));
                if (is_array($profile) && is_array($course)) {
                    $likes = $this->course_likes_model->find('course_likes', '*', array('course_id' => $_data['course_id'], 'user_id' => $_data['user_id']));

                    if (!is_array($likes)) {
                        $result = $this->course_likes_model->save($_data['course_id'], $_data['user_id']);
                        if ($result) {
                            $course_like['new_amount'] = $result;
                            $course_like['course_id'] = $_data['course_id'];
                            $course_like['status'] = '1';
                            $course_like['result'] = 'OK';
                        } else {
                            $course_like['result'] = 'NO ACTION';
                            $course_like['new_amount'] = $course[0]['amount'];
                            $course_like['course_id'] = $_data['course_id'];
                            $course_like['status'] = '1';
                        }
                    } else {
                        $course_like['new_amount'] = $course[0]['amount'];
                        $course_like['result'] = 'ALREADY SENT';
                    }
                } else {
                    $course_like['result'] = 'INVALID DATA';
                }
            }
        }
        echo json_encode($course_like);
    }

}

?>