{**
 * peerReview.tpl
 *
 * Copyright (c) 2000-2012 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * Subtemplate defining the author's peer review table.
 *
 * $Id$
 *}

<div id="peerReview">
<h3>{translate key="submission.peerReview"}</h3>

{assign var=start value="A"|ord}
{assign var=authorFiles value=$submission->getAuthorFileRevisions($stage)}
{assign var="directorFiles" value=$submission->getDirectorFileRevisions($stage)}
{assign var="viewableFiles" value=$authorViewableFilesByStage[$stage]}

<table class="data" width="100%">
	{if $stage == REVIEW_STAGE_PRESENTATION}
		<tr valign="top">
			<td class="label" width="20%">
				{translate key="submission.reviewVersion"}
			</td>
			<td class="value" width="80%">
				{assign var="reviewFile" value=$reviewFilesByStage[$stage]}
				{if $reviewFile}
					<a href="{url op="downloadFile" path=$submission->getPaperId()|to_array:$reviewFile->getFileId():$reviewFile->getRevision()}" class="file">{$reviewFile->getFileName()|escape}</a>&nbsp;&nbsp;{$reviewFile->getDateModified()|date_format:$dateFormatShort}
				{else}
					{translate key="common.none"}
				{/if}
			</td>
		</tr>
	{/if}
	<tr valign="top">
		<td class="label" width="20%">
			{translate key="submission.initiated"}
		</td>
		<td class="value" width="80%">
			{if $reviewEarliestNotificationByStage[$stage]}
				{$reviewEarliestNotificationByStage[$stage]|date_format:$dateFormatShort}
			{else}
				&mdash;
			{/if}
		</td>
	</tr>
	<tr valign="top">
		<td class="label" width="20%">
			{translate key="submission.lastModified"}
		</td>
		<td class="value" width="80%">
			{if $reviewModifiedByStage[$stage]}
				{$reviewModifiedByStage[$stage]|date_format:$dateFormatShort}
			{else}
				&mdash;
			{/if}
		</td>
	</tr>
	{if $stage == REVIEW_STAGE_PRESENTATION}
		<tr valign="top">
			<td class="label" width="20%">
				{translate key="submission.authorVersion"}
			</td>
			<td class="value" width="80%">
				{foreach from=$authorFiles item=authorFile key=key}
					<a href="{url op="downloadFile" path=$submission->getPaperId()|to_array:$authorFile->getFileId():$authorFile->getRevision()}" class="file">{$authorFile->getFileName()|escape}</a>&nbsp;&nbsp;{$authorFile->getDateModified()|date_format:$dateFormatShort}<br />
				{foreachelse}
					{translate key="common.none"}
				{/foreach}
			</td>
		</tr>
	{/if}

  {assign var="start" value="A"|ord}
	{foreach from=$reviewAssignments item=reviewAssignment key=reviewKey}
    {assign var="reviewId" value=$reviewAssignment->getId()}
    {if not $reviewAssignment->getCancelled()}
      {assign var="reviewIndex" value=$reviewIndexes[$reviewId]}
      <td class="label" width="20%">
        <h5>{translate key="user.role.reviewer"} {$reviewIndex+$start|chr}</h5>
      </td>
      <td class="value" width="80%">
        {if $reviewAssignment->getRecommendation() !== null && $reviewAssignment->getRecommendation() !== ''}
          {assign var="recommendation" value=$reviewAssignment->getRecommendation()}
          {translate key=$reviewerRecommendationOptions.$recommendation}
          &nbsp;&nbsp;&nbsp;&nbsp;
          <a href="javascript:openComments('{url op="viewReviewFormResponse" path=$submission->getPaperId()|to_array:$reviewAssignment->getId()}');" class="icon">{icon name="letter"}</a>
        {else}
          {translate key="common.none"}
        {/if}
      </td>
    {/if}
  {foreachelse}
    {translate key="common.noneAssigned"}
  {/foreach}
</table>
</div>
