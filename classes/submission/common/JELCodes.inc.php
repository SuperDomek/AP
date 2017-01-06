<?php

/**
 * @defgroup submission
 */

/**
 * @file JELCodes.inc.php
 *
 * Copyright (c) 2017 Dominik Blaha
 *  Inspiration from John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * @class JELCodes
 * @ingroup submission
 *
 * @brief Class for manipulating JEL codes.
 */

//$Id$

import('db.DBConnection');

class JELCodes {

	// Database connection object
	private $_dataSource;

	// JEL classification
	private $JELClassification = array();

  /**
  * Constructor.
  * Initalization the connection to database.
  *
  */
  function __construct(){
    if (!isset($dataSource)) {
			$this->_dataSource =& DBConnection::getConn();
		} else {
			$this->_dataSource = $dataSource;
		}
		$this->init();
  }

	/**
	*	Sets up the array with JEL Classification for the select in form
	*/
	function init(){
		$classification = array();
		$temp["General Economics"] = array(
			"A10" => "General",
			"A11" => "Role of Economics / Role of Economists / Market for Economists",
			"A12" => "Relation of Economics to Other Disciplines",
			"A13" => "Relation of Economics to Social Values",
			"A14" => "Sociology of Economics",
			"A19" => "Other"
		);
		$temp["Economic Education and Teaching of Economics"] = array(
			"A20" => "General",
			"A21" => "Pre-college",
			"A22" => "Undergraduate",
			"A23" => "Graduate",
			"A29" => "Other"
		);
		$this->JELClassification = $temp;
	}

	/**
	*	Returns an associative array with values for the select drop down list
	*	@return array
	*/
	function getClassification(){
		if(!empty($this->JELClassification)) return $this->JELClassification;
	}

	/**
	*	Returns a keyword for a given code
	* @return string
	*/
	function getKeyword($code){
		foreach ($this->JELClassification as $key => $optgroup) {
			foreach ($optgroup as $JELCode => $keyword) {
				if($JELCode === $code){
					return $keyword;
				}
			}
		}
		error_log("Error while getting JEL keyword: Key not found.");
		return false;
	}

  /**
	 * Returns an associative array with matching rows from the db for the paper
	 * @param $paper object
   * @return array
	 */
	function getCodes($paperID) {
    $conn = $this->_dataSource;
    if (isset($paperID)){
      $codes = $conn->Execute('SELECT * FROM paper_jel_codes WHERE paper_id = ?', array($paperID));
      if (!$codes) {
         print $conn->ErrorMsg();
       }
      else {
        $temp = array();
        //print "<pre>";
        while (!$codes->EOF) {
            //print $codes->fields[0].' '.$codes->fields[1]. ' ' . $codes->fields[2] . '<BR>';
            $temp[] = $codes->fields;
            $codes->MoveNext();
        }    $codes->Close(); # optional
        //print "</pre>";
        return $temp;
      }
    }
    else {
      error_log("Error while getting JEL codes: PaperID not set up.");
      return NULL;
    }

	}

	/**
	*	Sets up JEL code for given paper
	*	@param $paper_id ID of the paper to set up JEL code
	*	@param $code Code of the JEL keyword
	*	@param $keyword Classification keyword
	*/
	function setCode($paper_id, $key, $keyword){
		$conn = $this->_dataSource;
		if(isset($paper_id)){
			if(isset($key)){
				if(isset($keyword)){
					$sql = "INSERT INTO `paper_jel_codes`(`paper_id`, `code`, `code_keyword`) VALUES (?,?,?)";
					$err = $conn->Execute($sql, array($paper_id, $key, $keyword));
					if($err === false){
						error_log("Error while inserting JEL code: " . $conn->ErrorMsg());
					}
				}
				else {
					error_log("Error while setting up JEL code: keyword not set up.");
					return false;
				}
			}
			else {
				error_log("Error while setting up JEL code: key not set up.");
				return false;
			}
		}
		else {
			error_log("Error while setting up JEL code: Paper ID not set up.");
			return false;
		}
	}

}

?>
