{**
 * email.tpl
 *
 * Copyright (c) 2000-2012 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * Generic email template form
 *
 * $Id$
 *}
{strip}
{assign var="pageTitle" value="email.compose"}
{assign var="pageCrumbTitle" value="email.email"}
{include file="common/header.tpl"}
{/strip}

<script type="text/javascript">
{literal}
<!--
function deleteAttachment(fileId) {
	document.emailForm.deleteAttachment.value = fileId;
	document.emailForm.submit();
}
// -->
{/literal}
</script>

<form method="post" action="{$formActionUrl}"{if $attachmentsEnabled} enctype="multipart/form-data"{/if}>
<input type="hidden" name="continued" value="1"/>
{if $hiddenFormParams}
	{foreach from=$hiddenFormParams item=hiddenFormParam key=key}
		<input type="hidden" name="{$key|escape}" value="{$hiddenFormParam|escape}" />
	{/foreach}
{/if}

{if $attachmentsEnabled}
	<input type="hidden" name="deleteAttachment" value="" />
	{foreach from=$persistAttachments item=temporaryFile}
		{if is_object($temporaryFile)}<input type="hidden" name="persistAttachments[]" value="{$temporaryFile->getFileId()}" />{/if}
	{/foreach}
{/if}

{include file="common/formErrors.tpl"}

{foreach from=$errorMessages item=message}
	{if !$notFirstMessage}
		{assign var=notFirstMessage value=1}
		<h4>{translate key="form.errorsOccurred"}</h4>
		<ul class="plain">
	{/if}
	{if $message.type == MAIL_ERROR_INVALID_EMAIL}
		{translate|assign:"message" key="email.invalid" email=$message.address}
		<li>{$message|escape}</li>
	{/if}
{/foreach}

{if $notFirstMessage}
	</ul>
	<br/>
{/if}

<h3>{translate key="email.recipients"}</h3>
<table id="recipients" class="data" width="100%">
<tr valign="top">
	<td><input type="radio" id="allUsers" name="whichUsers" value="allUsers"/></td>
	<td class="label">
		<label for="allUsers">{translate key="director.notifyUsers.allUsers" count=$allUsersCount|default:0}</label>
	</td>
</tr>
<tr valign="top">
	<td><input type="radio" id="allAuthorsAbstractAccepted" name="whichUsers" value="allAuthorsAbstractAccepted"/></td>
	<td class="label">
		<label for="allAuthorsAbstractAccepted">{translate key="director.notifyUsers.allAuthorsAbstractAccepted" count=$allAuthorsAbstractAcceptedCount|default:0}</label>
	</td>
</tr>
<tr valign="top">
	<td><input type="radio" id="allAuthorsPaperAccepted" name="whichUsers" value="allAuthorsPaperAccepted"/></td>
	<td class="label">
		<label for="allAuthorsPaperAccepted">{translate key="director.notifyUsers.allAuthorsPaperAccepted" count=$allAuthorsPaperAcceptedCount|default:0}</label>
	</td>
</tr>
<tr valign="top">
	<td><input type="radio" id="allAuthorsAbstractRevisions" name="whichUsers" value="allAuthorsAbstractRevisions"/></td>
	<td class="label">
		<label for="allAuthorsAbstractRevisions">{translate key="director.notifyUsers.allAuthorsAbstractRevisions" count=$allAuthorsAbstractRevisionsCount|default:0}</label>
	</td>
</tr>
<tr valign="top">
	<td><input type="radio" id="allAuthorsPaperRevisions" name="whichUsers" value="allAuthorsPaperRevisions"/></td>
	<td class="label">
		<label for="allAuthorsPaperRevisions">{translate key="director.notifyUsers.allAuthorsPaperRevisions" count=$allAuthorsPaperRevisionsCount|default:0}</label>
	</td>
</tr>
<tr valign="top">
	<td><input type="radio" id="allAuthors" name="whichUsers" value="allAuthors"/></td>
	<td class="label">
		<label for="allAuthors">{translate key="director.notifyUsers.allAuthors" count=$allAuthorsCount|default:0}</label>
	</td>
</tr>
<tr valign="top">
	<td><input type="radio" id="allRegistrants" name="whichUsers" value="allRegistrants"/></td>
	<td class="label">
		<label for="allRegistrants">{translate key="director.notifyUsers.allRegistrants" count=$allRegistrantsCount|default:0}</label>
	</td>
</tr>
{if $senderEmail}
	<tr valign="top">
		<td><input type="checkbox" name="bccSender" value="1"{if $bccSender} checked{/if}/></td>
		<td class="label">
			{translate key="email.bccSender" address=$senderEmail|escape}
		</td>
	</tr>
{/if}
</table>

<br/>

<table id="emailBody" class="data" width="100%">
<tr valign="top">
	<td class="label">{translate key="email.from"}</td>
	<td class="value">{$from|escape}</td>
</tr>
<tr valign="top">
	<td width="20%" class="label">{fieldLabel name="subject" key="email.subject"}</td>
	<td width="80%" class="value"><input type="text" id="subject" name="subject" value="{$subject|escape}" size="60" maxlength="120" class="textField" /></td>
</tr>
<tr valign="top">
	<td class="label">{fieldLabel name="body" key="email.body"}</td>
	<td class="value"><textarea name="body" cols="60" rows="15" class="textArea">{$body|escape}</textarea></td>
</tr>
{if $attachmentsEnabled}
<tr valign="top">
	<td colspan="2">&nbsp;</td>
</tr>
<tr valign="top">
	<td class="label">{translate key="email.attachments"}</td>
	<td class="value">
		{assign var=attachmentNum value=1}
		{foreach from=$persistAttachments item=temporaryFile}
			{if is_object($temporaryFile)}
				{$attachmentNum|escape}.&nbsp;{$temporaryFile->getOriginalFileName()|escape}&nbsp;
				({$temporaryFile->getNiceFileSize()})&nbsp;
				<a href="javascript:deleteAttachment({$temporaryFile->getFileId()})" class="action">{translate key="common.delete"}</a>
				<br/>
				{assign var=attachmentNum value=$attachmentNum+1}
			{/if}
		{/foreach}

		{if $attachmentNum != 1}<br/>{/if}

		<input type="file" name="newAttachment" class="uploadField" /> <input name="addAttachment" type="submit" class="button" value="{translate key="common.upload"}" />
	</td>
</tr>
{/if}
</table>

<p><input name="send" type="submit" value="{translate key="email.send"}" class="button defaultButton" /> <input type="button" value="{translate key="common.cancel"}" class="button" onclick="history.go(-1)" /></p>
</form>

{include file="common/footer.tpl"}
