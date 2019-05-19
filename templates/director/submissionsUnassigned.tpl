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
		<td width="5%">{translate key="submissions.submit"}</td>
		<!--<td width="5%">{sort_search key="paper.sessionType" sort="sessionType"}</td>-->
		<td width="20%">{translate key="paper.authors"}</td>
		<td width="40%">{translate key="paper.title"}</td>
		<td width="10%">{translate key="paper.file"}</td>
    <td width="10%">{translate key="paper.manage"}</td>
	</tr>
	</thead>
	<tbody>
	{iterate from=submissions item=submission}
	{assign var="paperId" value=$submission->getPaperId()}
	<tr valign="top">
		<td>{$paperId}</td>
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
		<td><a href="{url op="submissionReview" path=$paperId|to_array:1}" class="action">{$submission->getLocalizedTitle()|default:$untitledPaper|strip_tags|truncate:60:"..."|default:"&mdash;"}</a></td>
		<td>
			{if $paperId|array_key_exists:$reviewFiles}
        {if $reviewFiles[$paperId] == 1}
          <span style="color:#0b9e3f;">{translate key="submission.fileAccepted"}</span>
        {else}
          <span style="color:#e85a09;">{translate key="submission.filePending"}</span>
        {/if}
      {else}
        <span style="color:#a5a3a5;">{translate key="submission.noFile"}</span>
      {/if}
		</td>
		<td style="text-align: center;">
			{assign var="currentStage" value=$submission->getCurrentStage()}
			{if $currentStage == $smarty.const.REVIEW_STAGE_ABSTRACT}
				<a href="{url op="submissionReview" path=$paperId|to_array:1}" class="action"><button class="button">{translate key="director.paper.recordDecision"}</button></a>
			{else}
				<a href="{url page="director" op="assignDirector" path="trackDirector" paperId=$paperId}"><button class="button">{translate key="director.paper.assignTrackDirector"}</button></a>
			{/if}
		</td>
	</tr>
{/iterate}
{if $submissions->wasEmpty()}
	<tr>
		<td colspan="7" class="nodata">{translate key="submissions.noSubmissions"}</td>
	</tr>
{/if}
</tbody>
</table>
<p>
{page_info iterator=$submissions}
{page_links anchor="submissions" name="submissions" iterator=$submissions searchField=$searchField searchMatch=$searchMatch search=$search track=$track sort=$sort sortDirection=$sortDirection}
</p>
</div>
