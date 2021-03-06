{**
 * submissionsInReview.tpl
 *
 * Copyright (c) 2000-2012 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * Show track director's submissions in review.
 *
 * $Id$
 *}
<div id="submissions">
<table width="100%" class="listing sortable">
	<thead>
	<tr>
		<td width="5%">{translate key="common.id"}</td>
		<td width="8%">{translate key="submissions.submit"}</td>
		<!--<td width="5%">{sort_search key="submissions.track" sort="track"}</td>-->
		<!--<td width="5%">{sort_search key="paper.sessionType" sort="sessionType"}</td>->
  <!--
		<td width="20%">{sort_search key="paper.authors" sort="authors"}</td>
  -->
		<td width="44%">{translate key="paper.title"}</td>
		<td width="25%" class="sorttable_nosort">
			<center style="border-bottom: 1px solid gray;margin-bottom: 3px;">{translate key="submission.peerReview"}</center>
			<table width="100%" class="nested sorttable_nosort">
				<tr valign="top">
					<td width="33%" style="padding: 0 4px 0 0; font-size: 1.0em">{translate key="submissions.reviewStage"}</td>
					<td width="33%" style="padding: 0 4px 0 0; font-size: 1.0em">{translate key="submission.ask"}</td>
					<!--<td width="25%" style="padding: 0 4px 0 0; font-size: 1.0em">{translate key="submission.due"}</td>-->
					<td width="33%" style="padding: 0 4px 0 0; font-size: 1.0em">{translate key="submission.done"}</td>
				</tr>
			</table>
		</td>
		<td width="10%">{translate key="submissions.ruling"}</td>
    <td width="6%">{translate key="submission.fileOkayed"}</td>
	</tr>
	</thead>
	<tbody>
{iterate from=submissions item=submission}

	{assign var="paperId" value=$submission->getPaperId()}
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
  <!--
		<td>{$submission->getAuthorString(true)|truncate:40:"..."|escape}</td>
  -->
		<td><a href="{url op="submissionReview" path=$submission->getPaperId()|to_array:$submission->getCurrentStage()}" class="action">{$submission->getLocalizedTitle()|strip_tags|truncate:40:"..."|default:"&mdash;"}</a></td>
		<td>
		<table width="100%">
			{assign var=displayedRound value=0}
			{foreach from=$submission->getReviewAssignments(null) item=reviewAssignmentTypes}
				{foreach from=$reviewAssignmentTypes item=assignment name=assignmentList}
					{assign var=displayedRound value=1}
					{if not $assignment->getCancelled() and not $assignment->getDeclined()}
					<tr valign="top">
						{assign var="stage" value=$assignment->getStage()}
						<td width="33%" style="padding: 0 4px 0 0; font-size: 1.0em">{if $stage == REVIEW_STAGE_ABSTRACT}{translate key="submission.abstract"}{else}{translate key="submission.paper"} {$assignment->getStage()-1}{/if}</td>
						<td width="33%" style="padding: 0 4px 0 0; font-size: 1.0em">{if $assignment->getDateAssigned()}{$assignment->getDateAssigned()|date_format:$dateFormatTrunc}{else}&mdash;{/if}</td>
						<!--<td width="25%" style="padding: 0 4px 0 0; font-size: 1.0em">{if $assignment->getDateCompleted() || !$assignment->getDateConfirmed()}&mdash;{else}{$assignment->getWeeksDue()|default:"&mdash;"}{/if}</td>-->
						<td width="33%" style="padding: 0 4px 0 0; font-size: 1.0em">{if $assignment->getDateCompleted()}{$assignment->getDateCompleted()|date_format:$dateFormatTrunc}{else}&mdash;{/if}</td>
					</tr>
					{/if}
				{/foreach}
			{/foreach}
			{if !$displayedRound}
				<tr valign="top">
					<td width="33%" style="padding: 0 4px 0 0; font-size: 1.0em">&mdash;</td>
					<td width="33%" style="padding: 0 4px 0 0; font-size: 1.0em">&mdash;</td>
					<!--<td width="25%" style="padding: 0 4px 0 0; font-size: 1.0em">&mdash;</td>-->
					<td width="33%" style="padding: 0 0 0 0; font-size:1.0em">&mdash;</td>
				</tr>
			{/if}
		</table>
		</td>
		<td>
			{assign var="decisions" value=$submission->getDecisions()|@end}
      {assign var="decision" value=$decisions|@end}
      {if $decision.decision == SUBMISSION_DIRECTOR_DECISION_ACCEPT}
        <span style="color:#0b9e3f;">ACC</span>
      {elseif $decision.decision == SUBMISSION_DIRECTOR_DECISION_PENDING_MINOR_REVISIONS ||
      $decision.decision == SUBMISSION_DIRECTOR_DECISION_PENDING_MAJOR_REVISIONS}
        <span style="color:#ea5b0d;">REV</span>
      {elseif $decisionAbstract.decision == SUBMISSION_DIRECTOR_DECISION_DECLINE}
        <span style="color:#e85a09;">DEC</span>
      {else}
        <span style="color:#a5a3a5;"></span>
      {/if}
		</td>
    <td style="vertical-align: middle;">
      {assign var=reviewFile value=$submission->getReviewFile()}
      {if $reviewFile}
        {if $reviewFile->getChecked() == 1}
          <span style="color:#0b9e3f;">{translate key="submission.fileAccepted"}</span>
        {else}
          <span style="color:#e85a09;">{translate key="submission.filePending"}</span>
        {/if}
      {else}
        <span style="color:#a5a3a5;">{translate key="submission.noFile"}</span>
      {/if}
    </td>
	</tr>
{/iterate}

{if $submissions->wasEmpty()}
	<tr>
		<td colspan="8" class="nodata">{translate key="submissions.noSubmissions"}</td>
	</tr>
{/if}
</tbody>
</table>
<p>
{page_info iterator=$submissions}
{page_links anchor="submissions" name="submissions" iterator=$submissions searchField=$searchField searchMatch=$searchMatch search=$search track=$track sort=$sort sortDirection=$sortDirection}
</p>
</div>
