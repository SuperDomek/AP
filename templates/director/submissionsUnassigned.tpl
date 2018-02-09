{**
 * submissionsUnassigned.tpl
 *
 * Copyright (c) 2000-2012 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * Show listing of unassigned submissions.
 *
 * $Id$
 *}
<div id="submissions">
<table width="100%" class="listing sortable">
	<thead>
	<tr>
		<td width="5%">{translate key="common.id"}</td>
		<td width="5%"><span class="disabled">MM-DD</span><br />{translate key="submissions.submit"}</td>
		<!--<td width="5%">{sort_search key="paper.sessionType" sort="sessionType"}</td>-->
		<td width="20%">{translate key="paper.authors"}</td>
		<td width="40%">{translate key="paper.title"}</td>
    <td width="20%">{translate key="paper.manage"}
	</tr>
	</thead>
	<tbody>
	{iterate from=submissions item=submission}
	<tr valign="top">
		<td>{$submission->getPaperId()}</td>
		<td>{$submission->getDateSubmitted()|date_format:$dateFormatTrunc}</td>
		<!--<td>
			{assign var="sessionTypeId" value=$submission->getData('sessionType')}
			{if $sessionTypeId}
				{assign var="sessionType" value=$sessionTypes.$sessionTypeId}
				{$sessionType->getLocalizedName()|escape}
			{/if}
		</td>-->
		<td>{$submission->getAuthorString(true)|truncate:40:"..."|escape}</td>
		{translate|assign:"untitledPaper" key="common.untitled"}
		{* EDIT: Hardcoded link to first review round - abstract*}
		<td><a href="{url op="submissionReview" path=$submission->getPaperId()|to_array:1}" class="action">{$submission->getLocalizedTitle()|default:$untitledPaper|strip_tags|truncate:60:"..."|default:"&mdash;"}</a></td>
		<td>
			{assign var="currentStage" value=$submission->getCurrentStage()}
			{if $currentStage == $smarty.const.REVIEW_STAGE_ABSTRACT}
				<a href="{url op="submissionReview" path=$submission->getPaperId()|to_array:1}" class="action"><button class="button">{translate key="director.paper.recordDecision"}</button></a>
			{else}
				<a href="{url page="director" op="assignDirector" path="trackDirector" paperId=$submission->getPaperId()}"><button class="button">{translate key="director.paper.assignTrackDirector"}</button></a>
			{/if}
		</td>
	</tr>
{/iterate}
{if $submissions->wasEmpty()}
	<tr>
		<td colspan="6" class="nodata">{translate key="submissions.noSubmissions"}</td>
	</tr>
{/if}
</tbody>
</table>
<p>
{page_info iterator=$submissions}
{page_links anchor="submissions" name="submissions" iterator=$submissions searchField=$searchField searchMatch=$searchMatch search=$search track=$track sort=$sort sortDirection=$sortDirection}
</p>
</div>
