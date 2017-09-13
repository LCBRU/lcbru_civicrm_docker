<?php
/*
+--------------------------------------------------------------------+
| CiviCRM version 4.7                                                |
+--------------------------------------------------------------------+
| Copyright CiviCRM LLC (c) 2004-2017                                |
+--------------------------------------------------------------------+
| This file is a part of CiviCRM.                                    |
|                                                                    |
| CiviCRM is free software; you can copy, modify, and distribute it  |
| under the terms of the GNU Affero General Public License           |
| Version 3, 19 November 2007 and the CiviCRM Licensing Exception.   |
|                                                                    |
| CiviCRM is distributed in the hope that it will be useful, but     |
| WITHOUT ANY WARRANTY; without even the implied warranty of         |
| MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.               |
| See the GNU Affero General Public License for more details.        |
|                                                                    |
| You should have received a copy of the GNU Affero General Public   |
| License and the CiviCRM Licensing Exception along                  |
| with this program; if not, contact CiviCRM LLC                     |
| at info[AT]civicrm[DOT]org. If you have questions about the        |
| GNU Affero General Public License or the licensing of CiviCRM,     |
| see the CiviCRM license FAQ at http://civicrm.org/licensing        |
+--------------------------------------------------------------------+
*/
/**
 * @package CRM
 * @copyright CiviCRM LLC (c) 2004-2017
 *
 * Generated from xml/schema/CRM/Dedupe/RuleGroup.xml
 * DO NOT EDIT.  Generated by CRM_Core_CodeGen
 * (GenCodeChecksum:025711212afbee5275704d4a7e63868f)
 */
require_once 'CRM/Core/DAO.php';
require_once 'CRM/Utils/Type.php';
/**
 * CRM_Dedupe_DAO_RuleGroup constructor.
 */
class CRM_Dedupe_DAO_RuleGroup extends CRM_Core_DAO {
  /**
   * Static instance to hold the table name.
   *
   * @var string
   */
  static $_tableName = 'civicrm_dedupe_rule_group';
  /**
   * Should CiviCRM log any modifications to this table in the civicrm_log table.
   *
   * @var boolean
   */
  static $_log = false;
  /**
   * Unique dedupe rule group id
   *
   * @var int unsigned
   */
  public $id;
  /**
   * The type of contacts this group applies to
   *
   * @var string
   */
  public $contact_type;
  /**
   * The weight threshold the sum of the rule weights has to cross to consider two contacts the same
   *
   * @var int
   */
  public $threshold;
  /**
   * Whether the rule should be used for cases where usage is Unsupervised, Supervised OR General(programatically)
   *
   * @var string
   */
  public $used;
  /**
   * Name of the rule group
   *
   * @var string
   */
  public $name;
  /**
   * Label of the rule group
   *
   * @var string
   */
  public $title;
  /**
   * Is this a reserved rule - a rule group that has been optimized and cannot be changed by the admin
   *
   * @var boolean
   */
  public $is_reserved;
  /**
   * Class constructor.
   */
  function __construct() {
    $this->__table = 'civicrm_dedupe_rule_group';
    parent::__construct();
  }
  /**
   * Returns all the column names of this table
   *
   * @return array
   */
  static function &fields() {
    if (!isset(Civi::$statics[__CLASS__]['fields'])) {
      Civi::$statics[__CLASS__]['fields'] = array(
        'id' => array(
          'name' => 'id',
          'type' => CRM_Utils_Type::T_INT,
          'title' => ts('Rule Group ID') ,
          'description' => 'Unique dedupe rule group id',
          'required' => true,
          'table_name' => 'civicrm_dedupe_rule_group',
          'entity' => 'RuleGroup',
          'bao' => 'CRM_Dedupe_BAO_RuleGroup',
        ) ,
        'contact_type' => array(
          'name' => 'contact_type',
          'type' => CRM_Utils_Type::T_STRING,
          'title' => ts('Contact Type') ,
          'description' => 'The type of contacts this group applies to',
          'maxlength' => 12,
          'size' => CRM_Utils_Type::TWELVE,
          'table_name' => 'civicrm_dedupe_rule_group',
          'entity' => 'RuleGroup',
          'bao' => 'CRM_Dedupe_BAO_RuleGroup',
          'html' => array(
            'type' => 'Select',
          ) ,
          'pseudoconstant' => array(
            'table' => 'civicrm_contact_type',
            'keyColumn' => 'name',
            'labelColumn' => 'label',
            'condition' => 'parent_id IS NULL',
          )
        ) ,
        'threshold' => array(
          'name' => 'threshold',
          'type' => CRM_Utils_Type::T_INT,
          'title' => ts('Threshold') ,
          'description' => 'The weight threshold the sum of the rule weights has to cross to consider two contacts the same',
          'required' => true,
          'table_name' => 'civicrm_dedupe_rule_group',
          'entity' => 'RuleGroup',
          'bao' => 'CRM_Dedupe_BAO_RuleGroup',
          'html' => array(
            'type' => 'Text',
          ) ,
        ) ,
        'used' => array(
          'name' => 'used',
          'type' => CRM_Utils_Type::T_STRING,
          'title' => ts('Length') ,
          'description' => 'Whether the rule should be used for cases where usage is Unsupervised, Supervised OR General(programatically)',
          'required' => true,
          'maxlength' => 12,
          'size' => CRM_Utils_Type::TWELVE,
          'table_name' => 'civicrm_dedupe_rule_group',
          'entity' => 'RuleGroup',
          'bao' => 'CRM_Dedupe_BAO_RuleGroup',
          'html' => array(
            'type' => 'Radio',
          ) ,
          'pseudoconstant' => array(
            'callback' => 'CRM_Core_SelectValues::getDedupeRuleTypes',
          )
        ) ,
        'name' => array(
          'name' => 'name',
          'type' => CRM_Utils_Type::T_STRING,
          'title' => ts('Name') ,
          'description' => 'Name of the rule group',
          'maxlength' => 64,
          'size' => CRM_Utils_Type::BIG,
          'table_name' => 'civicrm_dedupe_rule_group',
          'entity' => 'RuleGroup',
          'bao' => 'CRM_Dedupe_BAO_RuleGroup',
        ) ,
        'title' => array(
          'name' => 'title',
          'type' => CRM_Utils_Type::T_STRING,
          'title' => ts('Title') ,
          'description' => 'Label of the rule group',
          'maxlength' => 255,
          'size' => CRM_Utils_Type::HUGE,
          'table_name' => 'civicrm_dedupe_rule_group',
          'entity' => 'RuleGroup',
          'bao' => 'CRM_Dedupe_BAO_RuleGroup',
          'html' => array(
            'type' => 'Text',
          ) ,
        ) ,
        'is_reserved' => array(
          'name' => 'is_reserved',
          'type' => CRM_Utils_Type::T_BOOLEAN,
          'title' => ts('Reserved?') ,
          'description' => 'Is this a reserved rule - a rule group that has been optimized and cannot be changed by the admin',
          'table_name' => 'civicrm_dedupe_rule_group',
          'entity' => 'RuleGroup',
          'bao' => 'CRM_Dedupe_BAO_RuleGroup',
          'html' => array(
            'type' => 'CheckBox',
          ) ,
        ) ,
      );
      CRM_Core_DAO_AllCoreTables::invoke(__CLASS__, 'fields_callback', Civi::$statics[__CLASS__]['fields']);
    }
    return Civi::$statics[__CLASS__]['fields'];
  }
  /**
   * Return a mapping from field-name to the corresponding key (as used in fields()).
   *
   * @return array
   *   Array(string $name => string $uniqueName).
   */
  static function &fieldKeys() {
    if (!isset(Civi::$statics[__CLASS__]['fieldKeys'])) {
      Civi::$statics[__CLASS__]['fieldKeys'] = array_flip(CRM_Utils_Array::collect('name', self::fields()));
    }
    return Civi::$statics[__CLASS__]['fieldKeys'];
  }
  /**
   * Returns the names of this table
   *
   * @return string
   */
  static function getTableName() {
    return self::$_tableName;
  }
  /**
   * Returns if this table needs to be logged
   *
   * @return boolean
   */
  function getLog() {
    return self::$_log;
  }
  /**
   * Returns the list of fields that can be imported
   *
   * @param bool $prefix
   *
   * @return array
   */
  static function &import($prefix = false) {
    $r = CRM_Core_DAO_AllCoreTables::getImports(__CLASS__, 'dedupe_rule_group', $prefix, array());
    return $r;
  }
  /**
   * Returns the list of fields that can be exported
   *
   * @param bool $prefix
   *
   * @return array
   */
  static function &export($prefix = false) {
    $r = CRM_Core_DAO_AllCoreTables::getExports(__CLASS__, 'dedupe_rule_group', $prefix, array());
    return $r;
  }
}
