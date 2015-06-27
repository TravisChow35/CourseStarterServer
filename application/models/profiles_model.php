<?php

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

class Profiles_model extends CI_Model {

    public function __construct() {
        
    }

    function save( $data) {
        $this->db->insert('profiles', $data);
        return $this->db->insert_id();
    }

    public function get_profiles($id = null) {
        if ($id)
            return $this->find('profiles', '*', array('profiles.twitter_handle' => $id));
        else
            return $this->db->get('profiles')->result();
        // return $query->row_array();
    }

    public function login($imei) {
        if ($imei) {
            $user = $this->find('users', '*', array('users.imei' => $imei));
            //  var_dump($user);
            return $user;
        }
        return false;
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

    //update
    function update( $data, $where) {
        $this->db->update('profiles', $data, $where);
        return $this->db->affected_rows();
    }

//    delet
    function delete($id = null) {
        $this->db->delete('users', array('user_id' => $id));
        return $this->db->affected_rows();
    }

}
