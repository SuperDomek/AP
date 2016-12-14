<?php
/**
 * @defgroup plugins_generic_jelCode JEL Code Classification plugin
 */
/**
 * @file plugins/generic/exampleGenericPlugin/index.php
 *
 * Copyright (c) 2016 Study and Information Centre at CULS, Prague
 * Copyright (c) 2016 Dominik Bláha
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * @ingroup plugins_generic_jelCode
 * @brief Wrapper for JEL Code Classification plugin.
 *
 */
require_once('jelCode.inc.php');
return new jelCode();
?>
