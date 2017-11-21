{**
 * peerReview.tpl
 *
 * Copyright (c) 2000-2012 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * Subtemplate defining the peer review table.
 *
 * $Id$
 *}
<div id="submission">

<ul>
  {if $isDirector}
	<li><header>{translate key="paper.authors"}</header>
			{url|assign:"url" page="user" op="email" redirectUrl=$currentUrl to=$submission->getAuthorEmails() subject=$submission->getLocalizedTitle() paperId=$submission->getPaperId()}
			<a href="{$url}" alt="Mail the author" title="Mail the author">{$submission->getAuthorString()|escape}</a>{*icon name="mail" url=$url*}
</li>
  {/if}
<li><header>{translate key="paper.submitterId"}</header>
      {$submitterId}</li>
<li><header>{translate key="paper.title"}</header>
		{$submission->getLocalizedTitle()|strip_unsafe_html}</li>
<li><header>{translate key="track.track"}</header>
{$submission->getTrackTitle()|escape}</li>
<li><header>{translate key="user.role.trackDirector"}</header>
			{assign var=editAssignments value=$submission->getEditAssignments()}
			{foreach from=$editAssignments item=editAssignment}
				{assign var=emailString value=$editAssignment->getDirectorFullName()|concat:" <":$editAssignment->getDirectorEmail():">"}
				{url|assign:"url" page="user" op="email" redirectUrl=$currentUrl to=$emailString|to_array subject=$submission->getLocalizedTitle()|strip_tags paperId=$submission->getPaperId()}
				{$editAssignment->getDirectorFullName()|escape} {icon name="mail" url=$url}
				<br/>
			{foreachelse}
				{translate key="common.noneAssigned"}
			{/foreach}
			</li>
</div>

	{if $reviewingAbstractOnly}
	<div id="abstract">
	<h3>>{translate key="submission.abstract"}</h3>
		{* If this review level is for the abstract only, show the abstract. *}

			{$submission->getLocalizedAbstract()|strip_unsafe_html|nl2br|default:"&mdash;"}

		{if $abstractChangesLast}

{translate key="submission.abstractChangedDate"}

			{$abstractChangesLast->getDateLogged()|date_format:$dateFormatShort}


		{/if}
	</div>
	{/if}

{if ($stage == REVIEW_STAGE_PRESENTATION && $submission->getCurrentStage() < $smarty.const.REVIEW_STAGE_PRESENTATION)}
	{assign var="isStageDisabled" value=true}
{/if}

{if $isStageDisabled}
<div class="separator"></div>
	<table class="data" width="100%">
		<tr valign="middle">
			<td><h3>{translate key="submission.peerReview"}</h3></td>
		</tr>
		<tr>
			<td><span class="instruct">{translate key="director.paper.stageDisabled"}</span></td>
		</tr>
	</table>
{elseif $stage == $smarty.const.REVIEW_STAGE_ABSTRACT && $submission->getReviewMode() != $smarty.const.REVIEW_MODE_BOTH_SIMULTANEOUS}
{* No reviewers in abstract stage*}
{else}
<div class="separator"></div>
</div>

<div id="peerReview">
	<table class="data" width="100%">
		<tr valign="middle">
			<td width="20%">
				{if $submission->getReviewMode() == $smarty.const.REVIEW_MODE_BOTH_SIMULTANEOUS}
					<h3>{translate key="submission.review"}</h3>
				{elseif $stage >= $smarty.const.REVIEW_STAGE_PRESENTATION}
					<h3>{translate key="submission.paperReview"}</h3>
          <strong>{translate key="submission.stage" stage=$submission->getCurrentStage()-1}</strong><br />
				{/if}
			</td>
      {if $stage >= $smarty.const.REVIEW_STAGE_PRESENTATION}
      <td width="80%" class="nowrap">
				<a href="{url op="selectReviewer" path=$submission->getPaperId()}" class="action">{translate key="director.paper.selectReviewer"}</a>&nbsp;&nbsp;&nbsp;&nbsp;
				<a href="{url op="submissionRegrets" path=$submission->getPaperId()}" class="action">{translate|escape key="trackDirector.regrets.link"}</a>&nbsp;&nbsp;&nbsp;&nbsp;
			</td>
      {/if}
		</tr>
    {if $stage != $smarty.const.REVIEW_STAGE_ABSTRACT}
      {if $reviewFile}
        {if $reviewFile->getChecked() == 1}
		<tr valign="top">
			<td width="20%" class="label">{translate key="submission.reviewVersion"}</td>
			<td width="80%" class="value">
				<a href="{url op="downloadFile" path=$submission->getPaperId()|to_array:$reviewFile->getFileId():$reviewFile->getRevision()}" class="file" >{$reviewFile->getFileName()|escape}</a>&nbsp;&nbsp;({$reviewFile->getDateModified()|date_format:$dateFormatShort})
			</td>
		</tr>
					{if $stage > $smarty.const.REVIEW_STAGE_PRESENTATION}
		<tr valign="top">
			<td width="20%" class="label">{translate key="common.checklistOfAdjustments"}</td>
			<td width="80%" class="value">
				<span>{$changes|escape}</span>
			</td>
		</tr>
					{/if} {* $stage > $smarty.const.REVIEW_STAGE_PRESENTATION *}
				{elseif $isDirector} 
		<tr valign="top">
			<td width="20%" class="label">{translate key="submission.reviewVersion"}</td>
			<td width="80%" class="value">
				<a href="{url op="downloadFile" path=$submission->getPaperId()|to_array:$reviewFile->getFileId():$reviewFile->getRevision()}" class="file" title="{$reviewFile->getDateModified()|date_format:$dateFormatShort}">{$reviewFile->getFileName()|escape}</a>
			</td>
		</tr>
        {else} {* $reviewFile->getChecked() == 0 || !$isDirector *}
		<tr valign="top">
			<td width="20%" class="label">{translate key="submission.reviewVersion"}</td>
			<td class="warning value">{translate key="submission.fileNotChecked"}</td>
		</tr>
        {/if}
        {if $reviewFile->getChecked() == null && $isDirector}
		<tr valign="top">
			<td colspan="2">
				<form method="post" action="{url op="makeFileChecked"}">
					<input type="hidden" name="paperId" value="{$submission->getPaperId()}"/>
					<input type="hidden" name="fileId" value="{$reviewFile->getFileId()}"/>
					<input type="hidden" name="revision" value="{$reviewFile->getRevision()}"/>
					{translate key="editor.paper.confirmReviewFile"}<br />
					<button type="submit" name="checked" value="1" class="positive">{translate key="submission.fileOkay"}</button>
					&nbsp;
					<button type="submit" name="checked" value="0" class="negative">{translate key="submission.fileNotOkay"}</button>
				</form>
			</td>
		</tr>
        {elseif $reviewFile->getChecked() == 0 && $isDirector}
		<tr valign="top">
			<td width="20%" class="label">{translate key="director.paper.uploadReviewVersion"}</td>
			<td width="80%" class="nodata">
				<form method="post" action="{url op="uploadReviewVersion"}" enctype="multipart/form-data">
					<input type="hidden" name="paperId" value="{$submission->getPaperId()}" />
					<input type="file" name="upload" class="uploadField" />
					<input type="submit" name="submit" value="{translate key="common.upload"}" class="button" />
				</form>
			</td>
		</tr>
        {/if} {* $reviewFile->getChecked() *}
    				<!--&nbsp;&nbsp;&nbsp;&nbsp;<a class="action" href="javascript:openHelp('{get_help_id key="editorial.trackDirectorsRole.review.blindPeerReview" url="true"}')">{translate key="reviewer.paper.ensuringBlindReview"}</a> -->
  		{else} {* !$reviewFile *}
		<tr valign="top">
			<td width="20%" class="label">{translate key="submission.reviewVersion"}:</td>
			<td width="80%" class="value">
				{translate key="common.none"}
			</td>
		</tr>
  		{/if} {* $reviewFile *}
    {/if} {* $stage *}
	</table>

	{assign var="start" value="A"|ord}
	{foreach from=$reviewAssignments item=reviewAssignment key=reviewKey}
	{assign var="reviewId" value=$reviewAssignment->getId()}

  {* Grey out text if the file is not checked *}
  {if $stage != REVIEW_STAGE_ABSTRACT}
    {if $reviewFile}
      {if $reviewFile->getChecked() != 1}
        {assign var="greyOut" value=1}
      {/if}
    {else}
      {assign var="greyOut" value=1}
    {/if}
  {/if}

	{if not $reviewAssignment->getCancelled()}
		{assign var="reviewIndex" value=$reviewIndexes[$reviewId]}
		<div class="separator"></div>

		<table class="data" width="100%">
		<tr>
			<td width="20%"><h4>{translate key="user.role.reviewer"} {$reviewIndex+$start|chr}</h4></td>
			<td width="80%">
        <strong>{$reviewAssignment->getReviewerFullName()|escape}</strong>
        &nbsp;
        &nbsp;
        {*if $stage != REVIEW_STAGE_ABSTRACT*}
  					{if not $reviewAssignment->getDateNotified()}
  						<a href="{url op="clearReview" path=$submission->getPaperId()|to_array:$reviewAssignment->getId()}" class="action">{translate key="director.paper.clearReview"}</a>
  					{elseif $reviewAssignment->getDeclined() or not $reviewAssignment->getDateCompleted()}
  						<a href="{url op="cancelReview" paperId=$submission->getPaperId() reviewId=$reviewAssignment->getId()}" class="action">{translate key="director.paper.cancelReview"}</a>
  					{/if}
        {*/if*}
      </td>
		</tr>



    <!--
		<tr valign="top">
  		<td class="label">{translate key="submission.reviewForm"}</td>
  		<td>
    		{if $reviewAssignment->getReviewFormId()}
    			{assign var="reviewFormId" value=$reviewAssignment->getReviewFormId()}
    			{$reviewFormTitles[$reviewFormId]}
    		{else}
    			{translate key="manager.reviewForms.noneChosen"}
    		{/if}

  		</td>
	  </tr>
   -->
		<tr valign="top">
			<td colspan="2">
				<table width="100%" class="info">
					<tr>
						<td class="heading" width="25%">{translate key="submission.request"}</td>
						<td class="heading" width="25%">{translate key="submission.underway"}</td>
						<td class="heading" width="25%">{translate key="submission.due"}</td>
						<td class="heading" width="25%">{translate key="submission.acknowledge"}</td>
					</tr>
					<tr valign="top">
						<td>
							{url|assign:"reviewUrl" op="notifyReviewer" reviewId=$reviewAssignment->getId() paperId=$submission->getPaperId()}
							{if !$allowRecommendation}
								{icon name="mail" url=$reviewUrl disabled="true"}
							{elseif $reviewAssignment->getDateNotified()}
								{$reviewAssignment->getDateNotified()|date_format:$dateFormatShort}
							{else}
								{icon name="mail" url=$reviewUrl}
							{/if}
						</td>
						<td>
							{$reviewAssignment->getDateConfirmed()|date_format:$dateFormatShort|default:"&mdash;"}
						</td>
						<td>
							{if $reviewAssignment->getDeclined()}
								{translate key="trackDirector.regrets"}
							{else}
								<a href="{url op="setDueDate" path=$reviewAssignment->getPaperId()|to_array:$reviewAssignment->getId()}">{if $reviewAssignment->getDateDue()}{$reviewAssignment->getDateDue()|date_format:$dateFormatShort}{else}&mdash;{/if}</a>
							{/if}
						</td>
						<td>
							{url|assign:"thankUrl" op="thankReviewer" reviewId=$reviewAssignment->getId() paperId=$submission->getPaperId()}
							{if $reviewAssignment->getDateAcknowledged()}
								{$reviewAssignment->getDateAcknowledged()|date_format:$dateFormatShort}
							{elseif $reviewAssignment->getDateCompleted()}
								{icon name="mail" url=$thankUrl}
							{else}
								{icon name="mail" disabled="disabled" url=$thankUrl}
							{/if}
						</td>
					</tr>
				</table>
			</td>
		</tr>

    <tr>
  		<td colspan="2">&nbsp;</td>
  	</tr>
    <tbody {if $greyOut}style="color:#a5a3a5 !important;"{/if}>
		{if $reviewAssignment->getDateConfirmed() && !$reviewAssignment->getDeclined()}
			<tr valign="top" >
				<td class="label" width="20%">{translate key="reviewer.paper.recommendation"}</td>
				<td width="80%">
					{if $reviewAssignment->getRecommendation() !== null && $reviewAssignment->getRecommendation() !== ''}
						{assign var="recommendation" value=$reviewAssignment->getRecommendation()}
						{translate key=$reviewerRecommendationOptions.$recommendation}
						&nbsp;&nbsp;{$reviewAssignment->getDateCompleted()|date_format:$dateFormatShort}
					{else}
						{translate key="common.none"}&nbsp;&nbsp;&nbsp;&nbsp;
            {if $stage != $smarty.const.REVIEW_STAGE_ABSTRACT}
              {if $user->getId() != $reviewAssignment->getReviewerId()}
                {if $greyOut}
                  {translate key="reviewer.paper.sendReminder"}
                {else}
				          <a href="{url op="remindReviewer" paperId=$submission->getPaperId() reviewId=$reviewAssignment->getId()}" class="action">{translate key="reviewer.paper.sendReminder"}</a>
                {/if}
              {/if}
            {/if}
						{if $reviewAssignment->getDateReminded()}
							&nbsp;&nbsp;{$reviewAssignment->getDateReminded()|date_format:$dateFormatShort}
							{if $reviewAssignment->getReminderWasAutomatic()}
								&nbsp;&nbsp;{translate key="reviewer.paper.automatic"}
							{/if}
						{/if}
					{/if}
				</td>
			</tr>
			<!--<tr valign="top">
				<td class="label">{translate key="submission.review"}</td>
				<td>
					{if $reviewAssignment->getMostRecentPeerReviewComment()}
						{assign var="comment" value=$reviewAssignment->getMostRecentPeerReviewComment()}
						<a href="javascript:openComments('{url op="viewPeerReviewComments" path=$submission->getPaperId()|to_array:$reviewAssignment->getId() anchor=$comment->getId()}');" class="icon">{icon name="letter"}</a>&nbsp;&nbsp;{$comment->getDatePosted()|date_format:$dateFormatShort}
					{else}
						<a href="javascript:openComments('{url op="viewPeerReviewComments" path=$submission->getPaperId()|to_array:$reviewAssignment->getId()}');" class="icon">{icon name="letter"}</a>&nbsp;&nbsp;{translate key="submission.comments.noComments"}
					{/if}
				</td>
			</tr>-->

      <!-- This is the trackDirector's review -->
			{if $user->getId() == $reviewAssignment->getReviewerId()}
  			<tr valign="top">
          {if $reviewFormResponses[$reviewId]}
    				<td class="label">{translate key="submission.reviewFormResponse"}</td>
    				<td>
              {if $greyOut}
                {icon name="letter"}
              {else}
                <a href="javascript:openComments('{url op="viewReviewFormResponse" path=$submission->getPaperId()|to_array:$reviewAssignment->getId()}');" class="icon">{icon name="letter"}</a>
              {/if}
    				</td>
          {else}
            <td class="label">{translate key="submission.yourReviewFormResponse"}</td>
            <td>
              {if $greyOut}
                {translate key="submission.reviewForm"} {icon name="comment"}
              {else}
                <a href="javascript:openComments('{url op="editReviewFormResponse" path=$reviewId|to_array:$reviewAssignment->getReviewFormId()}');" class="icon">{translate key="submission.reviewForm"} {icon name="comment"}</a>
              {/if}
            </td>
          {/if}
  			</tr>
      {else}
      <tr valign="top">
        <td class="label">{translate key="submission.reviewFormResponse"}</td>
        <td>
          {if $greyOut}
            {icon name="letter"}
          {else}
            <a href="javascript:openComments('{url op="viewReviewFormResponse" path=$submission->getPaperId()|to_array:$reviewAssignment->getId()}');" class="icon">{icon name="letter"}</a>
          {/if}
        </td>
      </tr>
			{/if}
		{/if}

		{if (($reviewAssignment->getRecommendation() === null || $reviewAssignment->getRecommendation() === '') || !$reviewAssignment->getDateConfirmed()) && $reviewAssignment->getDateNotified() && !$reviewAssignment->getDeclined()}
			<tr valign="top">
				<td class="label">{translate key="reviewer.paper.directorToEnter"}</td>
				<td>
					{if !$reviewAssignment->getDateConfirmed()}
            {if $greyOut}
              {translate key="reviewer.paper.canDoReview"}&nbsp;&nbsp;&nbsp;&nbsp;{translate key="reviewer.paper.cannotDoReview"}
            {else}
				      <a href="{url op="confirmReviewForReviewer" path=$submission->getPaperId()|to_array:$reviewAssignment->getId() accept=1}" class="action">{translate key="reviewer.paper.canDoReview"}</a>&nbsp;&nbsp;&nbsp;&nbsp;<a href="{url op="confirmReviewForReviewer" path=$submission->getPaperId()|to_array:$reviewAssignment->getId() accept=0}" class="action">{translate key="reviewer.paper.cannotDoReview"}</a><br />
            {/if}
					{/if}
					{if $reviewAssignment->getDateConfirmed() && !$reviewAssignment->getDeclined()}
            <!-- This is the trackDirector's review -->
            {if $user->getId() == $reviewAssignment->getReviewerId()}
              {if $reviewFormResponses[$reviewId]}
    					  <a class="action" href="{url op="enterReviewerRecommendation" paperId=$submission->getPaperId() reviewId=$reviewAssignment->getId()}">{translate key="director.paper.recommendation"}</a>
              {else}
                {translate key="reviewer.paper.recomendation.formFirst"}
              {/if}
            {else}
              {if $greyOut}
                {translate key="director.paper.recommendation"}
              {else}
                <a class="action" href="{url op="enterReviewerRecommendation" paperId=$submission->getPaperId() reviewId=$reviewAssignment->getId()}">{translate key="director.paper.recommendation"}</a>
              {/if}
            {/if}
					{/if}
				</td>
			</tr>
		{/if}

		{if $reviewAssignment->getDateNotified() && !$reviewAssignment->getDeclined() && $rateReviewerOnQuality}
			<tr valign="top">
				<td class="label">{translate key="director.paper.rateReviewer"}</td>
				<td>
					<form method="post" action="{url op="rateReviewer"}">
					<input type="hidden" name="reviewId" value="{$reviewAssignment->getId()}" />
					<input type="hidden" name="paperId" value="{$submission->getPaperId()}" />
					{translate key="director.paper.quality"}&nbsp;
					<select name="quality" size="1" class="selectMenu">
						{html_options_translate options=$reviewerRatingOptions selected=$reviewAssignment->getQuality()}
					</select>&nbsp;&nbsp;
					<input type="submit" value="{translate key="common.record"}" class="button" />
					{if $reviewAssignment->getDateRated()}
						&nbsp;&nbsp;{$reviewAssignment->getDateRated()|date_format:$dateFormatShort}
					{/if}
				</form>
				</td>
			</tr>
		{/if}
  </tbody>
	</table>
	{/if}
	{/foreach}
</div>
{/if}

