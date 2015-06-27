<?php

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 * Description of products_model
 *
 * @author dell
 */
class Course_Likes_model extends CI_Model {

    public function __construct() {
        
    }

    function save($course_id, $user_id) {
        $this->db->insert('course_likes', array('course_id' => $course_id, 'user_id' => $user_id));
        if ($this->db->insert_id() > 0) {
            $course = $this->course_likes_model->find('courses', '*', array('id' => $course_id));
            $newval = intval($course[0]['amount']) + 5;
            $this->update('courses', array('amount' => $newval), array('id' => $course_id));
            return $newval;
            //
        } else
            return false;
    }

    function update($table, $data, $where) {
        $this->db->update($table, $data, $where);
        return $this->db->affected_rows();
    }

    function find($table, $select = false, $where = false, $joins = false, $joins_on = false, $group = false, $order = false, $having = false, $limit1 = false, $limit2 = false, $where_in = FALSE, $where_in_col = FALSE) {
        if ($select) {
            $this->db->select($select);
        } else {
            $this->db->select('*');
        }
        if (is_array($joins) && is_array($joins_on)) {
            $index = 0;
            foreach ($joins as $join) {
                $this->db->join($join, $joins_on[$index]);
                $index++;
            }
        } else {
            if ($joins && $joins_on) {
                $this->db->join($joins, $joins_on);
            }
        }
        if ($where) {
            //$where array or string
            $this->db->where($where);
        }
        if ($where_in) {
            //$where array or string
            $this->db->where_in($where_in_col, $where_in);
        }
        if ($group) {
            //$group array or string
            $this->db->group_by($group);
        }
        if ($order) {
            //$order string
            $this->db->order_by($order, 'desc');
        }
        if ($having) {
            //$having string or array
            $this->db->having($having);
        }
        if (!$limit2 && $limit1) {
            $this->db->limit($limit1);
        } else {
            if ($limit1) {
                $this->db->limit($limit1, $limit2);
            }
        }
        $query = $this->db->get($table);
        //echo $this->db->last_query(); die;
        //echo mysql_error();
        if ($query->num_rows() > 0) {
            return $query->result_array();
        } else {
            return false;
        }
    }

}

?>