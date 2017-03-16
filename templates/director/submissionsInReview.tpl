{**
 * submissionsInReview.tpl
 *
 * Copyright (c) 2000-2012 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * Show director's submissions in review.
 *
 * $Id$
 *}
<div id="submissions">
<table width="100%" class="listing">
	<tr>
		<td colspan="9" class="headseparator">&nbsp;</td>
	</tr>
	<tr class="heading" valign="bottom">
		<td width="4%">{sort_search key="common.id" sort="id"}</td>
		<td width="7%"><span class="disabled">MM-DD</span><br />{sort_search key="submissions.submitted" sort="submitDate"}</td>
		<!--<td width="5%">{sort_search key="submissions.track" sort="track"}</td>
		<td width="5%">{sort_search key="paper.sessionType" sort="sessionType"}</td>-->
		<td width="20%">{sort_search key="paper.authors" sort="authors"}</td>
		<td width="26%">{sort_search key="paper.title" sort="title"}</td>
		<td width="30%">
			<center style="border-bottom: 1px solid gray;margin-bottom: 3px;">{translate key="submission.peerReview"}</center>
			<table width="100%" class="nested">
				<tr valign="top">
					<td width="30%" style="padding: 0 4px 0 0; font-size: 1.0em">{translate key="submissions.reviewStage"}</td>
					<td width="25%" style="padding: 0 4px 0 0; font-size: 1.0em">{translate key="submission.ask"}</td>
					<td width="25%" style="padding: 0 4px 0 0; font-size: 1.0em">{translate key="submission.due"}</td>
					<td width="20%" style="padding: 0 4px 0 0; font-size: 1.0em">{translate key="submission.done"}</td>
				</tr>
			</table>
		</td>
		<td width="7%">{translate key="submissions.ruling"}</td>
    <td width="6%">{translate key="submission.fileOkayed"}</td>
	</tr>
	<tr>
		<td colspan="9" class="headseparator">&nbsp;</td>
	</tr>

	{iterate from=submissions item=submission}
  {assign var=paperId value=$submission->getPaperId()}
	<tr valign="top">
		<td>{$submission->getPaperId()}</td>
		<td>{$submission->getDateSubmitted()|date_format:$dateFormatTrunc}</td>
		<!--<td>{$submission->getTrackAbbrev()|escape}</td>
		<td>
			{assign var="sessionTypeId" value=$submission->getData('sessionType')}
			{if $sessionTypeId}
				{assign var="sessionType" value=$sessionTypes.$sessionTypeId}
				{$sessionType->getLocalizedName()|escape}
			{/if}
		</td>-->
		<td>{$submission->getAuthorString(true)|truncate:40:"..."|escape}</td>
		<td><a href="{url op="submissionReview" path=$submission->getPaperId()|to_array:$submission->getCurrentStage()}" class="action">{$submission->getLocalizedTitle()|strip_tags|truncate:40:"..."|default:"&mdash;"}</a></td>
		<td>
		<table width="100%">
			{foreach from=$submission->getReviewAssignments() item=reviewAssignments}
				{foreach from=$reviewAssignments item=assignment name=assignmentList}
					{if not $assignment->getCancelled() and not $assignment->getDeclined()}
					<tr valign="top">
						<td width="30%" style="padding: 0 4px 0 0; font-size: 1.0em">{if $assignment->getStage() == REVIEW_STAGE_ABSTRACT}{translate key="submission.abstract"}{else}{translate key="submission.paper"}{/if}</td>
						<td width="25%" style="padding: 0 4px 0 0; font-size: 1.0em">{if $assignment->getDateNotified()}{$assignment->getDateNotified()|date_format:$dateFormatTrunc}{else}&mdash;{/if}</td>
						<td width="25%" style="padding: 0 4px 0 0; font-size: 1.0em">{if $assignment->getDateCompleted() || !$assignment->getDateConfirmed()}&mdash;{else}{$assignment->getWeeksDue()|default:"&mdash;"}{/if}</td>
						<td width="20%" style="padding: 0 4px 0 0; font-size: 1.0em">{if $assignment->getDateCompleted()}{$assignment->getDateCompleted()|date_format:$dateFormatTrunc}{else}&mdash;{/if}</td>
					</tr>
					{/if}
				{foreachelse}
					<tr valign="top">
						<td width="30%" style="padding: 0 4px 0 0; font-size: 1.0em">&mdash;</td>
						<td width="25%" style="padding: 0 4px 0 0; font-size: 1.0em">&mdash;</td>
						<td width="25%" style="padding: 0 4px 0 0; font-size: 1.0em">&mdash;</td>
						<td width="20%" style="padding: 0 0 0 0; font-size: 1.0em">&mdash;</td>
					</tr>
				{/foreach}
			{foreachelse}
				<tr valign="top">
					<td width="30%" style="padding: 0 4px 0 0; font-size: 1.0em">&mdash;</td>
					<td width="25%" style="padding: 0 4px 0 0; font-size: 1.0em">&mdash;</td>
					<td width="25%" style="padding: 0 4px 0 0; font-size: 1.0em">&mdash;</td>
					<td width="20%" style="padding: 0 4px 0 0; font-size: 1.0em">&mdash;</td>
				</tr>
			{/foreach}
			</table>
		</td>
		<td>
			{foreach from=$submission->getDecisions() item=decisions}
				{foreach from=$decisions item=decision name=decisionList}
					{if $smarty.foreach.decisionList.last}
							{$decision.dateDecided|date_format:$dateFormatTrunc}<br />
					{/if}
				{foreachelse}
					&mdash;<br />
				{/foreach}
			{foreachelse}
				&mdash;<br />
			{/foreach}
		</td>
    <td style="vertical-align: middle;">
      {if $paperId|array_key_exists:$reviewFiles}
        {if $reviewFiles[$paperId] == 1}
          <span style="color:#0b9e3f;">{translate key="submission.fileAccepted""}</span>
        {else}
          <span style="color:#e85a09;">{translate key="submission.filePending"}</span>
        {/if}
      {else}
        <span style="color:#a5a3a5;">{translate key="submission.noFile"}</span>
      {/if}
    </td>
	</tr>
	<tr>
		<td colspan="8" class="{if $submissions->eof()}end{/if}separator">&nbsp;</td>
	</tr>
{/iterate}
{if $submissions->wasEmpty()}
	<tr>
		<td colspan="8" class="nodata">{translate key="submissions.noSubmissions"}</td>
	</tr>
	<tr>
		<td colspan="8" class="endseparator">&nbsp;</td>
	</tr>
{else}
	<tr>
		<td colspan="6" align="left">{page_info iterator=$submissions}</td>
		<td colspan="2" align="right">{page_links anchor="submissions" name="submissions" iterator=$submissions searchField=$searchField searchMatch=$searchMatch search=$search track=$track sort=$sort sortDirection=$sortDirection}</td>
	</tr>
{/if}
</table>
</div>
