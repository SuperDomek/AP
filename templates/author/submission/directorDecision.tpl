{**
 * peerReview.tpl
 *
 * Copyright (c) 2000-2012 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * Subtemplate defining the author's director decision table.
 *
 * $Id$
 *}

{literal}
<script type="text/javascript">
<!--
// turn on submit and upload after at least 10 chars submitted to the adjustments box
$('#file_changes').ready(function(){
	if (String($('#file_changes').val()).length > 10) {
		document.getElementById("revision_submit").disabled = "";
		document.getElementById("revision_upload").disabled = "";
	}
	else {
		document.getElementById("revision_upload").disabled = "disabled";
		document.getElementById("revision_submit").disabled = "disabled";
	}
});
$('#file_changes').live('input',function() {
	if (String($(this).val()).length > 10) {
		document.getElementById("revision_submit").disabled = "";
		document.getElementById("revision_upload").disabled = "";
	}
	else {
		document.getElementById("revision_upload").disabled = "disabled";
		document.getElementById("revision_submit").disabled = "disabled";
	}
});
// -->
</script>
{/literal}

<div id="directorDecision">
<h3>{translate key="submission.directorDecision"}</h3>

{assign var=authorFiles value=$submission->getAuthorFileRevisions($submission->getCurrentStage())}
{assign var=directorFiles value=$submission->getDirectorFileRevisions($submission->getCurrentStage())}
<form method="post" action="{url op="uploadRevisedVersion"}" enctype="multipart/form-data">
<table width="100%" class="data">
	<tr valign="top">
		<td class="label" width="20%">{translate key="director.paper.decision"}</td>
		<td class="value" width="80%">
			{if $lastDirectorDecision}
				{assign var="decision" value=$lastDirectorDecision.decision}
				<strong>{translate key=$directorDecisionOptions.$decision}</strong> ({$lastDirectorDecision.dateDecided|date_format:$dateFormatShort})
			{else}
				&mdash;
			{/if}
		</td>
	</tr>
	{if $lastDirectorDecision.decision == SUBMISSION_DIRECTOR_DECISION_PENDING_REVISIONS ||
		$lastDirectorDecision.decision == SUBMISSION_DIRECTOR_DECISION_PENDING_MINOR_REVISIONS ||
		$lastDirectorDecision.decision == SUBMISSION_DIRECTOR_DECISION_PENDING_MAJOR_REVISIONS}
		{if $lastDecisionComment}
			<tr valign="top">
				<td class="label" width="20%">{translate key="submission.directorDecisionComment"}</td>
				<td class="value" width="80%">
					<p>{$lastDecisionComment->getComments()|escape}</p>
					<!--<textarea disabled="disabled" class="textArea" rows="5" cols="40">{$lastDecisionComment->getComments()}</textarea>-->
				</td>
			</tr>
		{/if}
	{/if}

  <!--
	<tr valign="top">
		<td class="label" width="20%">
			{translate key="submission.notifyDirector"}
		</td>
		<td class="value" width="80%">
			{url|assign:"notifyAuthorUrl" op="emailDirectorDecisionComment" paperId=$submission->getPaperId()}
			{icon name="mail" url=$notifyAuthorUrl}
			&nbsp;&nbsp;&nbsp;&nbsp;
			{translate key="submission.directorAuthorRecord"}
			{if $submission->getMostRecentDirectorDecisionComment()}
				{assign var="comment" value=$submission->getMostRecentDirectorDecisionComment()}
				<a href="javascript:openComments('{url op="viewDirectorDecisionComments" path=$submission->getPaperId() anchor=$comment->getId()}');" class="icon">{icon name="comment"}</a> {$comment->getDatePosted()|date_format:$dateFormatShort}
			{else}
				<a href="javascript:openComments('{url op="viewDirectorDecisionComments" path=$submission->getPaperId()}');" class="icon">{icon name="comment"}</a>{translate key="common.noComments"}
			{/if}
		</td>
	</tr>
-->

	

  {if $lastDirectorDecision.decision == SUBMISSION_DIRECTOR_DECISION_PENDING_MINOR_REVISIONS ||
		$lastDirectorDecision.decision == SUBMISSION_DIRECTOR_DECISION_PENDING_MAJOR_REVISIONS}
		<tr>
			<td colspan="2" class="separator">&nbsp;</td>
		</tr>
		<tr valign="top">
			<td colspan="2">
				<h4>{translate key="author.paper.uploadAuthorVersion"}</h4>
			</td>
		</tr>
		<tr valign="top">
			<td class="label" width="20%">
				<label for="file_changes">{translate key="submission.fileChanges"}*</label>
			</td>
			<td class="value" width="80%">
				<input type="hidden" name="paperId" value="{$submission->getPaperId()}" />
				<textarea id="file_changes" name="file_changes" class="textArea" rows="15" cols="60">{$changes|escape}</textarea>
			</td>
		</tr>
    {if $authorFiles}
    	<tr valign="top">
    		<td class="label" width="20%">
    			{translate key="submission.authorVersion"}
    		</td>
    		<td class="value" width="80%">
    			{foreach from=$authorFiles item=authorFile key=key}
    				<a href="{url op="downloadFile" path=$submission->getPaperId()|to_array:$authorFile->getFileId():$authorFile->getRevision()}" class="file">{$authorFile->getFileName()|escape}</a>&nbsp;&nbsp;{$authorFile->getDateModified()|date_format:$dateFormatShort}
    				{if $mayEditPaper}
    					&nbsp;&nbsp;&nbsp;&nbsp;
    					<a href="{url op="deletePaperFile" path=$submission->getPaperId()|to_array:$authorFile->getFileId():$authorFile->getRevision()}" class="action">{translate key="common.delete"}</a>
    				{/if}
    				<br />
    			{foreachelse}
    				{translate key="common.none"}
    			{/foreach}
    		</td>
    	</tr>
    {/if}
	<tr valign="top">
		<td class="label" width="20%">
			<label for="revision_upload">{translate key="author.paper.uploadAuthorVersion"}</label>
		</td>
		<td class="value" width="80%">
				<input type="file" name="revision_upload" id="revision_upload" class="uploadField" disabled="disabled" />
				<input type="submit" name="revision_submit" id="revision_submit" value="{translate key="common.upload"}" class="button" disabled="disabled" />
		</td>
	</tr>
  {/if}
</table>
</form>
</div>
