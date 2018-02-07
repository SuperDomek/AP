{**
 * metadataView.tpl
 *
 * Copyright (c) 2000-2012 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * View (but not edit) metadata of a paper. Used by MetadataForm.
 *
 * $Id$
 *}
{strip}
{assign var="pageTitle" value="submission.viewMetadata"}
{include file="common/header.tpl"}
{/strip}

{if $canViewAuthors}
<h3>{translate key="paper.authors"}</h3>

<table width="100%" class="data">
	{foreach name=authors from=$authors key=authorIndex item=author}
	<tr valign="top">
		<td width="20%" class="label">{translate key="user.name"}</td>
		<td width="80%" class="value">
			{assign var=emailString value=$author.firstName|concat:" ":$author.middleName:" ":$author.lastName:" <":$author.email:">"}
			{url|assign:"url" page="user" op="email" to=$emailString|to_array redirectUrl=$currentUrl paperId=$paperId}
			{$author.firstName|escape} {$author.middleName|escape} {$author.lastName|escape} {icon name="mail" url=$url}
		</td>
	</tr>
	<!--<tr valign="top">
		<td class="label">{translate key="user.url"}</td>
		<td class="value">{$author.url|escape|default:"&mdash;"}</td>
	</tr>-->
	<tr valign="top">
		<td class="label">{translate key="user.affiliation"}</td>
		<td class="value">{$author.affiliation|escape|nl2br|default:"&mdash;"}</td>
	</tr>
	<!--<tr valign="top">
		<td class="label">{translate key="user.biography"}</td>
		<td class="value">{$author.biography.$formLocale|strip_unsafe_html|nl2br|default:"&mdash;"}</td>
	</tr>-->
  {*<tr valign="top">
  	<td width="20%" class="label">{fieldLabel name="authors-$authorIndex-attends" key="common.attends"}</td>
  	<td width="80%" class="value">
  		<input type="checkbox" name="authors[{$authorIndex|escape}][attends]" id="authors-{$authorIndex|escape}-attends" {if !$authors.attends} checked="checked" {/if}/>
  	</td>
  </tr>*}
	{if !$smarty.foreach.authors.last}
	<tr>
		<td colspan="2" class="separator">&nbsp;</td>
	</tr>
	{/if}
	{/foreach}
</table>


<div class="separator"></div>
{/if}


<h3>{translate key="submission.titleAndAbstract"}</h3>

<table width="100%" class="data">
	<tr valign="top">
		<td width="20%" class="label">{translate key="paper.title"}</td>
		<td width="80%" class="value">{$title[$formLocale]|strip_unsafe_html|default:"&mdash;"}</td>
	</tr>

	<tr>
		<td colspan="2" class="separator">&nbsp;</td>
	</tr>
	<tr valign="top">
		<td class="label">{translate key="paper.abstract"}</td>
		<td class="value">{$abstract[$formLocale]|strip_unsafe_html|nl2br|default:"&mdash;"}</td>
	</tr>
</table>


<div class="separator"></div>


<h3>{translate key="submission.indexing"}</h3>

<table width="100%" class="data">
	{if $currentSchedConf->getSetting('metaDiscipline')}
	<tr valign="top">
		<td width="20%" class="label">{translate key="paper.discipline"}</td>
		<td width="80%" class="value">{$discipline[$formLocale]|escape|default:"&mdash;"}</td>
	</tr>
	<tr>
		<td colspan="2" class="separator">&nbsp;</td>
	</tr>
	{/if}

{* JEL Code *}

	{if $currentSchedConf->getSetting('metaSubjectClass')}
  <tr valign="top">
		<td width="20%"  class="label">{translate key="paper.subjectClassification"}</td>
		<td width="80%" class="value">
      {foreach name=JELCodes from=$JELCodes item=JELCode}
        {$JELCode.2}<br>
      {foreachelse}
        {translate key="paper.subjectClassification.noItems"}
      {/foreach}
    </td>
	</tr>
	<tr>
		<td colspan="2" class="separator">&nbsp;</td>
	</tr>
	{/if}

	{if $currentSchedConf->getSetting('metaSubject')}
	<tr valign="top">
		<td width="20%" class="label">{translate key="paper.subject"}</td>
		<td width="80%" class="value">{$subject[$formLocale]|escape|default:"&mdash;"}</td>
	</tr>
	<tr>
		<td colspan="2" class="separator">&nbsp;</td>
	</tr>
	{/if}
	{if $currentSchedConf->getSetting('metaCoverage')}
	<tr valign="top">
		<td width="20%" class="label">{translate key="paper.coverageGeo"}</td>
		<td width="80%" class="value">{$coverageGeo[$formLocale]|escape|default:"&mdash;"}</td>
	</tr>
	<tr>
		<td colspan="2" class="separator">&nbsp;</td>
	</tr>
	<tr valign="top">
		<td class="label">{translate key="paper.coverageChron"}</td>
		<td class="value">{$coverageChron[$formLocale]|escape|default:"&mdash;"}</td>
	</tr>
	<tr>
		<td colspan="2" class="separator">&nbsp;</td>
	</tr>
	<tr valign="top">
		<td class="label">{translate key="paper.coverageSample"}</td>
		<td class="value">{$coverageSample[$formLocale]|escape|default:"&mdash;"}</td>
	</tr>
	<tr>
		<td colspan="2" class="separator">&nbsp;</td>
	</tr>
	{/if}
	{if $currentSchedConf->getSetting('metaType')}
	<tr valign="top">
		<td width="20%" class="label">{translate key="paper.type"}</td>
		<td width="80%" class="value">{$type[$formLocale]|escape|default:"&mdash;"}</td>
	</tr>
	<tr>
		<td colspan="2" class="separator">&nbsp;</td>
	</tr>
	{/if}
	<tr valign="top">
		<td width="20%" class="label">{translate key="paper.language"}</td>
		<td width="80%" class="value">{$language|escape|default:"&mdash;"}</td>
	</tr>
</table>


<div class="separator"></div>


<h3>{translate key="submission.supportingAgencies"}</h3>

<table width="100%" class="data">
	<tr valign="top">
		<td width="20%" class="label">{translate key="submission.agencies"}</td>
		<td width="80%" class="value">{$sponsor[$formLocale]|escape|default:"&mdash;"}</td>
	</tr>
</table>

<div class="separator"></div>

<h3>{translate key="submission.supportingAgencies"}</h3>
{assign var=publish value=$submission->getPublish()}
<p>{translate key="author.submit.publishSubmission"}&nbsp;<input type="checkbox" name="publish" id="publish" value="Yes" {if $publish == 1}checked="checked"{/if} disabled="disabled"/></p>

{include file="common/footer.tpl"}
