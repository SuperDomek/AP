{**
 * selectTrackDirector.tpl
 *
 * Copyright (c) 2000-2012 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * List directors or track directors and give the ability to select one.
 *
 * $Id$
 *}
{strip}
{assign var="pageTitle" value=$roleName|concat:"s"}
{include file="common/header.tpl"}
{/strip}

<h3>{translate key="director.paper.selectDirector" roleName=$roleName|translate}</h3>

<form name="submit" method="post" action="{url op="assignDirector" path=$rolePath paperId=$paperId}">
	<select name="searchField" size="1" class="selectMenu">
		{html_options_translate options=$fieldOptions selected=$searchField}
	</select>
	<select name="searchMatch" size="1" class="selectMenu">
		<option value="contains"{if $searchMatch == 'contains'} selected="selected"{/if}>{translate key="form.contains"}</option>
		<option value="is"{if $searchMatch == 'is'} selected="selected"{/if}>{translate key="form.is"}</option>
		<option value="startsWith"{if $searchMatch == 'startsWith'} selected="selected"{/if}>{translate key="form.startsWith"}</option>
	</select>
	<input type="text" name="search" class="textField" value="{$search|escape}" />&nbsp;<input type="submit" value="{translate key="common.search"}" class="button" />
</form>

<p>{foreach from=$alphaList item=letter}<a href="{url op="assignDirector" path=$rolePath paperId=$paperId searchInitial=$letter}">{if $letter == $searchInitial}<strong>{$letter|escape}</strong>{else}{$letter|escape}{/if}</a> {/foreach}<a href="{url op="assignDirector" paperId=$paperId}">{if $searchInitial==''}<strong>{translate key="common.all"}</strong>{else}{translate key="common.all"}{/if}</a></p>

<div id="directors">
<table width="100%" class="listing sortable">
<thead>
	<tr>
		<td width="30%">{translate key="user.name"}</td>
		<td width="15%">{translate key="track.tracks"}</td>
		<td width="15%">{translate key="common.queue.short.submissionsAccepted"}</td>
		<td width="15%">{translate key="common.queue.short.submissionsInReview"}</td>
		<td width="15%">{translate key="submissions.declined"}</td>
		<td width="10%">{translate key="common.action"}</td>
	</tr>
</thead>
<tbody>
{iterate from=directors item=director}
{assign var=directorId value=$director->getId()}
<tr valign="top">
	<td><a class="action" href="{url op="userProfile" path=$directorId}">{$director->getFullName()|escape}</a></td>
	<td>
		{assign var=thisDirectorTracks value=$directorTracks[$directorId]}
		{foreach from=$thisDirectorTracks item=track}
			{$track->getLocalizedAbbrev()|escape}&nbsp;
		{foreachelse}
			&mdash;
		{/foreach}
	</td>
	<td>
		{if $directorStatistics[$directorId] && $directorStatistics[$directorId].complete}
			{$directorStatistics[$directorId].complete}
		{else}
			0
		{/if}
	</td>
	<td>
		{if $directorStatistics[$directorId] && $directorStatistics[$directorId].incomplete}
			{$directorStatistics[$directorId].incomplete}
		{else}
			0
		{/if}
	</td>
	<td>
		{if $directorStatistics[$directorId] && $directorStatistics[$directorId].declined}
			{$directorStatistics[$directorId].declined}
		{else}
			0
		{/if}
	</td>
	<td><a class="action" href="{url op="assignDirector" paperId=$paperId directorId=$directorId}"><button class="button">{translate key="common.assign"}</button></a></td>
</tr>
{/iterate}
{if $directors->wasEmpty()}
<tr>
<td colspan="6" class="nodata">{translate key="manager.people.noneEnrolled"}</td>
</tr>
{else}
	<tr>
		<td colspan="3" align="left">{page_info iterator=$directors}</td>
		<td colspan="3" align="right">{page_links anchor="directors" name="directors" iterator=$directors searchInitial=$searchInitial searchField=$searchField searchMatch=$searchMatch search=$search dateFromDay=$dateFromDay dateFromYear=$dateFromYear dateFromMonth=$dateFromMonth dateToDay=$dateToDay dateToYear=$dateToYear dateToMonth=$dateToMonth paperId=$paperId}</td>
	</tr>
{/if}
</tbody>
</table>
</div>
{include file="common/footer.tpl"}
