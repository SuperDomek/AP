<?php
/**
 * @file plugins/generic/exampleGenericPlugin/jelCode.inc.php
 *
 * Copyright (c) 2016 Study and Information Centre at CULS, Prague
 * Copyright (c) 2016 Dominik Bláha
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * @class jelCode
 * @ingroup plugins_generic_jelCode
 *
 * @brief This plugin adds JEL classification to submission creation. See
 */
import('classes.plugins.GenericPlugin');
class jelCode extends GenericPlugin {

  function getName() {
		return 'jelCode';
	}
	/**
	 * Register the plugin, if enabled
	 * @param $category string
	 * @param $path string
	 * @return boolean
	 */
	function register($category, $path) {
		if (parent::register($category, $path)) {
			if ($this->getEnabled()) {
				// You could register for hooks here if needed
				HookRegistry::register('TemplateManager::display',array($this, 'callback'));
			}
			return true;
		}
		return false;
	}
	/**
	 * Hook callback function for TemplateManager::display
	 * @param $hookName string
	 * @param $args array
	 * @return boolean
	 */
	function callback($hookName, $args) {
		// Get the template manager from the hook parameters.
		$templateManager =& $args[0];
    import('notification.NotificationManager');
  	$notificationManager = new NotificationManager();
  	$notificationManager->createTrivialNotification('notification.notification', 'Hello World! From plugin jelCode');
		// Permit additional plugins to use this hook; returning true
		// here would interrupt processing of this hook instead.
		return false;
	}

  /**
   * Get the filename of the ADODB schema for this plugin.
   */
  function getInstallSchemaFile() {
    return $this->getPluginPath() . '/' . 'schema.xml';
  }

  /**
   * Determine whether or not this plugin is enabled.
   */
  function getEnabled() {
    $conference =& Request::getConference();
    $conferenceId = $conference?$conference->getId():0;
    return $this->getSetting($conferenceId, 0, 'enabled');
  }


  /**
	 * Set the enabled/disabled state of this plugin
	 */
	function setEnabled($enabled) {
		$conference =& Request::getConference();
		$conferenceId = $conference?$conference->getId():0;
		$this->updateSetting($conferenceId, 0, 'enabled', $enabled);

		return true;
	}



	/**
	 * Get the display name of this plugin
	 * @return string
	 */
	function getDisplayName() {
		return __('plugins.generic.jelCode.name');
	}
	/**
	 * Get the description of this plugin
	 * @return string
	 */
	function getDescription() {
		return __('plugins.generic.jelCode.description');
	}
	/**
	 * Get a list of available management verbs for this plugin
	 * @return array
	 */
	function getManagementVerbs() {
    $verbs = array();
    if ($this->getEnabled()) {
			$verbs[] = array(
				'disable',
				__('manager.plugins.disable')
			);
		} else {
			$verbs[] = array(
				'enable',
				__('manager.plugins.enable')
			);
		}
		return $verbs;
	}
	/**
	 * @see Plugin::manage()
	 */
	function manage($verb, $args) {
		switch ($verb) {
      case 'enable':
				$this->setEnabled(true);
				break;
      case 'disable':
				$this->setEnabled(false);
				break;
			default:
				assert(false, "Unknown management verb");
		}
    return false;
	}
}
?>
