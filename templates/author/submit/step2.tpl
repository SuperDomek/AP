{**
 * step2.tpl
 *
 * Copyright (c) 2000-2012 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * Step 2 of author paper submission.
 *
 * $Id$
 *}

{if !$showAbstractSteps}
	{assign var="pageTitle" value="author.submit.step2NoAbstracts"}
{else}
	{assign var="pageTitle" value="author.submit.step2"}
{/if}
{include file="author/submit/submitHeader.tpl"}

{include file="common/formErrors.tpl"}

{url|assign:"url" page="author" op="submissionReview" path=$paperId|to_array:1}
{translate key="author.submit.uploadInformation" abstractURL=$url}

<a href="{$publicFilesDir}/ap2018-paper-template.docx">{translate key="author.submit.paperTemplate"}</a><br />

<p>{translate key="author.submit.removeAuthorInfo"}<br />
<a href="{$publicFilesDir}/Remove_author_info.pdf">{translate key="author.submit.removeAuthorInfoManual"}</a>
</p>

<div class="separator"></div>
{if $uploadOpen}

<form method="post" action="{url op="saveSubmit" path=$submitStep}" enctype="multipart/form-data">
<input type="hidden" name="paperId" value="{$paperId|escape}" />

<div id="submissionFileInfo">
<h3>{translate key="author.submit.submissionFile"}</h3>
<table class="data" width="100%">
{if $submissionFile}
<tr valign="top">
	<td width="20%" class="label">{translate key="common.fileName"}</td>
	<td width="80%" class="value"><a href="{url op="download" path=$paperId|to_array:$submissionFile->getFileId()}">{$submissionFile->getFileName()|escape}</a></td>
</tr>
<tr valign="top">
	<td width="20%" class="label">{translate key="common.originalFileName"}</td>
	<td width="80%" class="value">{$submissionFile->getOriginalFileName()|escape}</td>
</tr>
<tr valign="top">
	<td width="20%" class="label">{translate key="common.fileSize"}</td>
	<td width="80%" class="value">{$submissionFile->getNiceFileSize()}</td>
</tr>
<tr valign="top">
	<td width="20%" class="label">{translate key="common.dateUploaded"}</td>
	<td width="80%" class="value">{$submissionFile->getDateUploaded()|date_format:$datetimeFormatShort}</td>
</tr>
{else}
<tr valign="top">
	<td colspan="2" class="nodata">{translate key="author.submit.noSubmissionFile"}</td>
</tr>
{/if}
</table>
</div>

<div class="separator"></div>

<div id="uploadFile">
<table class="data" width="100%">
<tr>
	<td width="30%" class="label">
		{if $submissionFile}
			{fieldLabel name="submissionFile" key="author.submit.replaceSubmissionFile"}
		{else}
			{fieldLabel name="submissionFile" key="author.submit.uploadSubmissionFile"}
		{/if}
	</td>
	<td width="70%" class="value"><input type="file" class="uploadField" name="submissionFile" id="submissionFile" /> <input name="uploadSubmissionFile" type="submit" class="button" value="{translate key="common.upload"}" /></td>
</tr>
</table>
</div>

<div class="separator"></div>

<p><input type="submit"{if !$submissionFile} onclick="return confirm('{translate|escape:"jsparam" key="author.submit.noSubmissionConfirm"}')"{/if} value="{translate key="common.saveAndContinue"}" class="button defaultButton" /> <input type="button" value="{translate key="common.cancel"}" class="button" onclick="confirmAction('{url page="author"}', '{translate|escape:"jsparam" key="author.submit.cancelSubmission"}')" /></p>

</form>
{else}
<p class="warning">
{translate key="common.uploadDeadlinePassed"}
</p>
{/if}
<!--<div class="separator"></div>
{translate key="author.submit.uploadInstructions"}
{if $currentSchedConf->getSetting('supportPhone')}
	{assign var="howToKeyName" value="author.submit.howToSubmit"}
{else}
	{assign var="howToKeyName" value="author.submit.howToSubmitNoPhone"}
{/if}

<p>{translate key=$howToKeyName supportName=$currentSchedConf->getSetting('supportName') supportEmail=$currentSchedConf->getSetting('supportEmail') supportPhone=$currentSchedConf->getSetting('supportPhone')}</p>
-->
{include file="common/footer.tpl"}
