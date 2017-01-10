<?php

/**
 * @file Affiliations.inc.php
 *
 * Copyright (c) 2016 Dominik Bláha
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * @ingroup pages_user
 *
 * @brief Set up affiliations and addresses.
 * Returns false if the affiliation and addresses keys are not consistent
 */

//$Id$

import('i18n.PKPLocale');

class Affiliations {
  // to store affiliations
  private $affiliations = array();

  // to store addresses
  private $addresses = array();

  // to store CompanyIds
  private $companyIds = array();

  // to store VATRegNos
  private $VATRegNos = array();

  function __construct() {
    $locale = AppLocale::getLocale();
    switch($locale) {
      case "cs_CZ":
        $this->affiliations["CULS"] = "Česká zemědělská univerzita";
        $this->affiliations["FEM"] = "ČZU, Provozně ekonomická fakulta";
        $this->affiliations["else"] = "Jiné";
        break;
      case "en_US":
        $this->affiliations["CULS"] = "Czech University of Life Sciences";
        $this->affiliations["FEM"] = "CULS, Faculty of Economics and Management";
        $this->affiliations["else"] = "Specify bellow";
        break;
    }

    // Initialization of addresses
    // The array keys need to be consistent with affiliations keys
    $this->addresses["CULS"] = "Česká zemědělská univerzita v Praze\\nKamýcká 129\\n165 00 Praha 6 - Suchdol";
    $this->addresses["FEM"] = "Provozně ekonomická fakulta\\nČeská zemědělská univerzita v Praze\\nKamýcká 129\\n165 21 Praha 6 - Suchdol";

    // Initialization of CompanyIds
    $this->companyIds["CULS"] = "60460709";
    // Initialization of VATRegNos
    $this->VATRegNos["CULS"] = "CZ60460709";

    return $this->checkConsistency();
  }

  /**
   * Cycles through the addresses array and checks that there is a corresponding
   * key in affiliations array
   * Returns false if not consistent
   */
  private function checkConsistency() {
    foreach ($this->addresses as $key => $value){
      if(!array_key_exists($key, $this->affiliations)){
        error_log("Error while creating Affiliation object:The address and affiliation keys are not consistent.");
        return false;
      }
    }
    return true;
  }

  /**
   * Returns the array with affiliations
   * @return array String
   */
  function getAffiliations(){
    if(!empty($this->affiliations)){
      return $this->affiliations;
    }
  }

  /**
   * Returns the array with addresses
   * @return array String
   */
  function getAddresses(){
    if(!empty($this->addresses)){
      return $this->addresses;
    }
  }

  /**
   * Returns the array with Company Ids
   * @return array String
   */
  function getCompanyIds(){
    if(!empty($this->companyIds)){
      return $this->companyIds;
    }
    else error_log("Error getting companyIds.");
  }

  /**
   * Returns the array with VAT Registration Numbers
   * @return array String
   */
  function getVatRegNos(){
    if(!empty($this->VATRegNos)){
      return $this->VATRegNos;
    }
    else error_log("Error getting VAT Reg. numbers.");
  }
}


?>
