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

	var $_dataSource;

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
        print "<pre>";
        while (!$codes->EOF) {
            print $codes->fields[0].' '.$codes->fields[1]. ' ' . $codes->fields[2] . '<BR>';
            $temp[] = $codes->fields;
            $codes->MoveNext();
        }    $codes->Close(); # optional
        print "</pre>";
        return $temp;
      }
    }
    else {
      error_log("Error while getting JEL codes: PaperID not set up.");
      return NULL;
    }

	}


}

?>
