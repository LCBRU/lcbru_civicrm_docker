<?php
/*
 +--------------------------------------------------------------------+
 | CiviCRM version 4.7                                                |
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
 * Field handler to provide relationship to CiviCRM email.
*
* @ingroup civicrm_relationship_handlers
*/
class civicrm_handler_relationship_address extends civicrm_handler_relationship_location {

  function option_definition() {
    $options = parent::option_definition();
    $options['is_billing'] = array('default' => 0);
    return $options;
  }

  function options_form(&$form, &$form_state) {
    parent::options_form($form, $form_state);
    $form['is_billing'] = array(
      '#type' => 'checkbox',
      '#title' => 'Use only Billing Address record?',
      '#options' => array(0 => 'No', 1 => 'Yes'),
      '#description' => t('Check above box if you want only the <strong>Billing Address</strong> record used in this relationship.'),
      '#default_value' => $this->options['is_billing'],
      '#fieldset' => 'location_choices',
    );
  }

  function join_address($join = array()) {
    $extra = array();
    if (isset($join->extra)) {
      $extra = $join->extra;
    }
    if (isset($this->options['is_billing']) && $this->options['is_billing']) {
      $extra[] = array(
        'value' => $this->options['is_billing'],
        'numeric' => TRUE,
        'field' => 'is_billing',
        'operator' => '=',
      );
    }
    if (!empty($extra)) {
      $join->extra = $extra;
    }
    return $join;
  }

  function get_join() {
    $join = parent::get_join();
    $join = $this->join_address($join);
    return $join;
  }


  /**
   * Called to implement a relationship in a query.
   */
  function query() {
    $join = $this->get_join();
    $this->alias = $this->query->add_table($this->table, $this->relationship, $join);
    //register relationship
    $this->view->relationship[$this->options['id']]->alias = $this->alias;
    $this->query->relationships[$this->alias] = array(
      'link' => $this->relationship,
      'table' => $this->table,
      'base' => $this->table,
    );
  }
}
