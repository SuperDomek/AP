{**
 * profile.tpl
 *
 * Copyright (c) 2000-2012 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * User profile form.
 *
 * $Id$
 *}
{strip}
{assign var="pageTitle" value="user.profile.editProfile"}
{url|assign:"url" op="profile"}
{include file="common/header.tpl"}
{/strip}

{literal}
<script type="text/javascript">
<!--
// Sets up address
// @key string Abbreviation for faculty to set up; if null the erase address
function setAddress(key){
  // process addresses from smarty into a javascript variable
  var addresses = {{/literal}
    {foreach from=$addresses item=address key=key name=addressloop}
          "{$key}":"{$address}"
    {if !$smarty.foreach.addressloop.last},{/if}
    {/foreach}{literal}
  };
  // set up address in address field
  if (key == null) {
    document.getElementById("mailingAddress").value = "";
    //tinyMCE.get('mailingAddress').setContent("");
  }
  else{
    document.getElementById("mailingAddress").value = addresses[key];
    //tinyMCE.get('mailingAddress').setContent(addresses[key]);
  }
}

// Inits the affiliation select box by the textarea content
function initSelect() {
  // process affiliations array from smarty into a javascript associative array
  var affiliations = {{/literal}
    {foreach from=$affiliations item=affiliation key=key name=affiliationloop}
          "{$key}":"{$affiliation}"
    {if !$smarty.foreach.affiliationloop.last},{/if}
    {/foreach}{literal}
  };
  var affil_select_name = "affil_select";
  var affil_box = "affil_box";
  // var affiliation_text = document.getElementById("affil_text").value;
  var affiliation_text = "{/literal}{$user->getAffiliation()}{literal}";
  var affiliation_key = val2key(affiliation_text, affiliations);
  if (affiliation_key){
    document.getElementById(affil_select_name).value = affiliation_key;
    document.getElementById("affil_text").value = affiliations[affiliation_key];
  }
  else if (affiliation_text != ""){
    document.getElementById(affil_select_name).value = "else";
    document.getElementById(affil_box).style.display = "table-row";
    document.getElementById("affil_text").value = "{/literal}{$user->getAffiliation()}{literal}";
  }
  else {
    document.getElementsByName(affil_select_name).value = "";
  }
}

// returns key of a searched value in an associative array
function val2key(val,array){
    for (var key in array) {
        this_val = array[key];
        if(this_val == val){
            return key;
            break;
        }
    }
    return false;
}

// shows affiliation box if required; sets up address if affiliation set up
function showAffilBox(sel) {
  var selected = sel.options[sel.selectedIndex];
	if(selected.value == "else"){ //custom affil
    document.getElementById("affil_box").style.display = "table-row";
    // clean the prefilled boxes
    document.getElementById("affil_text").value = "";
    setAddress(null);
  }
  else if (selected.value != ""){ //selected affil
    document.getElementById("affil_box").style.display = "none";
    document.getElementById("affil_text").value = selected.text;
    setAddress(selected.value);
  }
  else { // blank affil
    document.getElementById("affil_box").style.display = "none";
  }
}
// -->
</script>
{/literal}

<form name="profile" method="post" action="{url op="saveProfile"}" enctype="multipart/form-data">

{include file="common/formErrors.tpl"}

<table class="data" width="100%">
{if count($formLocales) > 1}
	<tr valign="top">
		<td width="20%" class="label">{fieldLabel name="formLocale" required="true" key="common.language"}</td>
		<td width="80%" class="value">
			{url|assign:"userProfileUrl" page="user" op="profile" escape=false}
			{form_language_chooser form="profile" url=$userProfileUrl}
			<span class="instruct">{translate key="form.formLanguage.description"}</span>
		</td>
	</tr>
{/if}
<tr valign="top">
	<td width="20%" class="label">{fieldLabel suppressId="true" name="username" key="user.username"}</td>
	<td width="80%" class="value">{$username|escape}</td>
</tr>
<tr valign="top">
	<td class="label">{fieldLabel name="salutation" key="user.salutation"}</td>
	<td class="value"><input type="text" name="salutation" id="salutation" value="{$salutation|escape}" size="20" maxlength="40" class="textField" /></td>
</tr>
<tr valign="top">
	<td class="label">{fieldLabel name="firstName" required="true" key="user.firstName"}</td>
	<td class="value"><input type="text" name="firstName" id="firstName" value="{$firstName|escape}" size="20" maxlength="40" class="textField" /></td>
</tr>
<tr valign="top">
	<td class="label">{fieldLabel name="middleName" key="user.middleName"}</td>
	<td class="value"><input type="text" name="middleName" id="middleName" value="{$middleName|escape}" size="20" maxlength="40" class="textField" /></td>
</tr>
<tr valign="top">
	<td class="label">{fieldLabel name="lastName" required="true" key="user.lastName"}</td>
	<td class="value"><input type="text" name="lastName" id="lastName" value="{$lastName|escape}" size="20" maxlength="90" class="textField" /></td>
</tr>
<tr valign="top">
	<td class="label">{fieldLabel name="initials" key="user.initials"}</td>
	<td class="value"><input type="text" name="initials" id="initials" value="{$initials|escape}" size="5" maxlength="5" class="textField" />&nbsp;&nbsp;{translate key="user.initialsExample"}</td>
</tr>
<tr valign="top">
	<td class="label">{fieldLabel name="gender" key="user.gender"}</td>
	<td class="value">
		<select name="gender" id="gender" size="1" class="selectMenu">
			{html_options_translate options=$genderOptions selected=$gender}
		</select>
	</td>
</tr>

<tr valign="top" >
	<td class="label">{fieldLabel name="affiliation" key="user.affiliation" required="true"}</td>
	<td class="value">
    <select name="affiliation_select" id="affil_select" class="selectMenu" onchange="showAffilBox(this);">
      <option value=""></option>
      {html_options options=$affiliations selected=$affiliation_select}
    </select>
  </td>
</tr>
<tr valign="top" id="affil_box" {if $affiliation_select neq 'else'}class="hidden"{/if}>
  <td class="label">
  </td>
  <td class="value">
    <textarea name="affiliation" id="affil_text" rows="5" cols="40" class="textArea">{$user->getAffiliation()|escape}</textarea>
  </td>
</tr>

<tr valign="top">
	<td class="label">{fieldLabel name="signature" key="user.signature"}</td>
	<td class="value"><textarea name="signature[{$formLocale|escape}]" id="signature" rows="5" cols="40" class="textArea">{$signature[$formLocale]|escape}</textarea></td>
</tr>
<tr valign="top">
	<td class="label">{fieldLabel name="email" required="true" key="user.email"}</td>
	<td class="value"><input type="text" name="email" id="email" value="{$email|escape}" size="30" maxlength="90" class="textField" /></td>
</tr>
<tr valign="top">
	<td class="label">{fieldLabel name="userUrl" key="user.url"}</td>
	<td class="value"><input type="text" name="userUrl" id="userUrl" value="{$userUrl|escape}" size="30" maxlength="90" class="textField" /></td>
</tr>
<tr valign="top">
	<td class="label">{fieldLabel name="phone" key="user.phone"}</td>
	<td class="value"><input type="text" name="phone" id="phone" value="{$phone|escape}" size="15" maxlength="24" class="textField" /></td>
</tr>
<tr valign="top">
	<td class="label">{fieldLabel name="fax" key="user.fax"}</td>
	<td class="value"><input type="text" name="fax" id="fax" value="{$fax|escape}" size="15" maxlength="24" class="textField" /></td>
</tr>
<tr valign="top">
	<td class="label">{fieldLabel name="mailingAddress" key="common.mailingAddress"}</td>
	<td class="value"><textarea name="mailingAddress" id="mailingAddress" rows="5" cols="40" class="textArea">{$mailingAddress|escape}</textarea></td>
</tr>

<tr valign="top">
	<td class="label">{fieldLabel name="billingAddress" key="common.billingAddress"}</td>
	<td class="value"><textarea name="billingAddress" id="billingAddress" rows="4" cols="40" class="textArea">{$billingAddress|escape}</textarea></td>
</tr>

<tr valign="top">
	<td class="label">{fieldLabel name="companyId" key="common.companyId"}</td>
	<td class="value"><input type="text" name="companyId" id="companyId" size="15" maxlength="24" class="textField" value="{$companyId|escape}"/></td>
</tr>

<tr valign="top">
	<td class="label">{fieldLabel name="VATRegNo" key="common.VATRegNo"}</td>
	<td class="value"><input type="text" name="VATRegNo" id="VATRegNo" size="15" maxlength="24" class="textField" value="{$VATRegNo|escape}"/></td>
</tr>

<tr valign="top">
	<td class="label">{fieldLabel name="country" key="common.country"}</td>
	<td class="value">
		<select name="country" id="country" class="selectMenu">
			<option value=""></option>
			{html_options options=$countries selected=$country}
		</select>
	</td>
</tr>

<tr valign="top">
	<td class="label">{fieldLabel name="timeZone" key="common.timeZone"}</td>
	<td class="value">
		<select name="timeZone" id="timeZone" class="selectMenu">
			<option value=""></option>
			{html_options options=$timeZones selected=$timeZone}
		</select>
	</td>
</tr>
<tr valign="top">
	<td class="label">{fieldLabel name="interests" key="user.interests"}</td>
	<td class="value"><textarea name="interests[{$formLocale|escape}]" id="interests" rows="5" cols="40" class="textArea">{$interests[$formLocale]|escape}</textarea></td>
</tr>
<tr valign="top">
	<td class="label">{fieldLabel name="biography" key="user.biography"}<br />{translate key="user.biography.description"}</td>
	<td class="value"><textarea name="biography[{$formLocale|escape}]" id="biography" rows="5" cols="40" class="textArea">{$biography[$formLocale]|escape}</textarea></td>
</tr>
<tr valign="top">
       <td class="label">
	       {fieldLabel name="profileImage" key="user.profile.form.profileImage"}
       </td>
       <td class="value">
	       <input type="file" id="profileImage" name="profileImage" class="uploadField" /> <input type="submit" name="uploadProfileImage" value="{translate key="common.upload"}" class="button" />
	       {if $profileImage}
		       {translate key="common.fileName"}: {$profileImage.name|escape} {$profileImage.dateUploaded|date_format:$datetimeFormatShort} <input type="submit" name="deleteProfileImage" value="{translate key="common.delete"}" class="button" />
		       <br />
		       <img src="{$sitePublicFilesDir}/{$profileImage.uploadName|escape:"url"}" width="{$profileImage.width|escape}" height="{$profileImage.height|escape}" style="border: 0;" alt="{translate key="user.profile.form.profileImage"}" />
	       {/if}
       </td>
</tr>

{if $allowRegReader || $allowRegAuthor || $allowRegReviewer}
	<tr valign="top">
		<td class="label">{translate key="user.roles"}</td>
		<td class="value">
			{if $allowRegReader}
				<input type="checkbox" id="readerRole" name="readerRole" {if $isReader || $readerRole}checked="checked" {/if}/>&nbsp;{fieldLabel name="readerRole" key="user.role.reader"}<br/>
			{/if}
			{if $allowRegAuthor}
				<input type="checkbox" id="authorRole" name="authorRole" {if $isAuthor || $authorRole}checked="checked" {/if}/>&nbsp;{fieldLabel name="authorRole" key="user.role.author"}<br/>
			{/if}
			{if $allowRegReviewer}
				<input type="checkbox" id="reviewerRole" name="reviewerRole" {if $isReviewer || $reviewerRole}checked="checked" {/if}/>&nbsp;{fieldLabel name="reviewerRole" key="user.role.reviewer"}<br/>
			{/if}
		</td>
	</tr>
{/if}

{if $displayOpenAccessNotification}
	{assign var=notFirstSchedConf value=0}
	{foreach from=$schedConfs name=schedConfOpenAccessNotifications key=thisSchedConfId item=thisSchedConf}
		{assign var=thisSchedConfId value=$thisSchedConf->getId()}
		{assign var=enableOpenAccessNotification value=$thisSchedConf->getSetting('enableOpenAccessNotification')}
		{assign var=notificationEnabled value=$user->getSetting('openAccessNotification', $thisSchedConfId)}
		{if !$notFirstSchedConf}
			{assign var=notFirstSchedConf value=1}
			<tr valign="top">
				<td class="label">{translate key="user.profile.form.openAccessNotifications"}</td>
				<td class="value">
		{/if}

		{if $enableOpenAccessNotification}
			<input type="checkbox" name="openAccessNotify[]" {if $notificationEnabled}checked="checked" {/if}id="openAccessNotify-{$thisSchedConfId|escape}" value="{$thisSchedConfId|escape}" /> <label for="openAccessNotify-{$thisSchedConfId|escape}">{$thisSchedConf->getFullTitle()|escape}</label><br/>
		{/if}

		{if $smarty.foreach.schedConfOpenAccessNotifications.last}
				</td>
			</tr>
		{/if}
	{/foreach}
{/if}

</table>

<p><input type="submit" value="{translate key="common.save"}" class="button defaultButton" /> <input type="button" value="{translate key="common.cancel"}" class="button" onclick="document.location.href='{url page="user"}'" /></p>
</form>

<p><span class="formRequired">{translate key="common.requiredField"}</span></p>

{* Initialization of the affiliation select boxes on first load of submit page *}
{if $firstLoad}
{literal}
<script type="text/javascript">
  initSelect();
</script>
{/literal}{/if}

{include file="common/footer.tpl"}
