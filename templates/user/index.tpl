{**
 * index.tpl
 *
 * Copyright (c) 2000-2012 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * User index.
 *
 * $Id$
 *}
{strip}
{assign var="pageTitle" value="user.userHome"}
{include file="common/header.tpl"}
{/strip}

{literal}
<script type="text/javascript">
<!--
function revealHide(obj){
	var messageShow = '{/literal}{translate key="common.previousSchedConfs.show"}{literal}';
	var messageHide = '{/literal}{translate key="common.previousSchedConfs.hide"}{literal}';
	if(obj.style.display == 'none' || obj.style.display == ''){
		obj.style.display = "block";
		document.getElementById('hideButton').innerHTML = messageHide;
	}
	else{
		obj.style.display = "none";
		document.getElementById('hideButton').innerHTML = messageShow;
	}
};

function showMenu(){
	var years = document.getElementsByClassName("hiddenMenu");
	for (var i = 0; i < years.length; i++){
		revealHide(years[i]);
	}
};
// -->
</script>
{/literal}

{if $isSiteAdmin}
{*assign var="hasRole" value=1*}
	&#187; <a href="{url conference="index" page=$isSiteAdmin->getRolePath()}">{translate key=$isSiteAdmin->getRoleName()}</a>
	{call_hook name="Templates::User::Index::Admin"}
{/if}

{if !$currentConference}<h3>{translate key="user.myConferences"}</h3>{/if}

{foreach from=$userConferences item=conference}

{assign var="conferenceId" value=$conference->getId()}
{assign var="conferencePath" value=$conference->getPath()}

<div id="conference">
  {if $isValid.ConferenceManager.$conferenceId.0}
<h4><a href="{url conference=$conference->getPath() page="user"}">{$conference->getConferenceTitle()|escape}</a></h4>

	{* Display conference roles *}

	<table width="100%" class="info">
			<tr>
				<td>&#187; <a href="{url conference=$conferencePath page="manager"}">{translate key="user.role.manager"}</a></td>
				<td></td>
				<td></td>
				<td></td>
				<td align="right">{if $setupIncomplete.$conferenceId}[<a href="{url conference=$conferencePath schedConf=$schedConfPath  page="manager" op="setup" path="1"}">{translate key="manager.schedConfSetup"}</a>]{/if}</td>
			</tr>

	</table>
{/if}
	{* Display scheduled conference roles *}
	{assign var="schedConfsCount" value=$userSchedConfs[$conferenceId]|@count}
	{foreach from=$userSchedConfs[$conferenceId] item=schedConf name=schedConfs}
		{assign var="schedConfId" value=$schedConf->getId()}
		{assign var="schedConfPath" value=$schedConf->getPath()}
		{if $schedConf->getCurrent()}
			{if !$isValid.Director.$conferenceId.$schedConfId &&
			!$isValid.TrackDirector.$conferenceId.$schedConfId &&
			!$isValid.Reviewer.$conferenceId.$schedConfId &&
			!$isValid.Author.$conferenceId.$schedConfId &&
			$isValid.Reader.$conferenceId.$schedConfId}
			{assign var="hasRole" value=0}
			{else}
			{assign var="hasRole" value=1}
			{/if}
			<div id="schedConf-{$schedConf->getSequence()}">
		{elseif $smarty.foreach.schedConfs.iteration == 2}
			<button type="button" onclick="showMenu();" id="hideButton">{translate key="common.previousSchedConfs.show"}</button>
			<div id="schedConf-{$schedConf->getSequence()}" class="hiddenMenu">
		{else}
			<div id="schedConf-{$schedConf->getSequence()}" class="hiddenMenu">
		{/if}
		
		<h5><a href="{url conference=$conference->getPath() schedConf=$schedConf->getPath() page="index"}">{$schedConf->getSchedConfTitle()|escape}</a></h5>

		<table width="100%" class="info">
			{if $isValid.Director.$conferenceId.$schedConfId}
				<tr>
					{assign var="directorSubmissionsCount" value=$submissionsCount.Director.$conferenceId.$schedConfId}
					<td>&#187; <a href="{url conference=$conferencePath schedConf=$schedConfPath  schedConf=$schedConfPath page="director"}">{translate key="user.role.director"}</a></td>
					<td>{if $directorSubmissionsCount[0]}
							<a href="{url conference=$conferencePath schedConf=$schedConfPath  page="director" op="submissions" path="submissionsUnassigned"}">{$directorSubmissionsCount[0]} {translate key="common.queue.short.submissionsUnassigned"}</a>
						{else}<span class="disabled">0 {translate key="common.queue.short.submissionsUnassigned"}</span>{/if}
					</td>
					<td>
						{if $directorSubmissionsCount[1]}
							<a href="{url conference=$conferencePath schedConf=$schedConfPath  page="director" op="submissions" path="submissionsInReview"}">{$directorSubmissionsCount[1]} {translate key="common.queue.short.submissionsInReview"}</a>
						{else}
							<span class="disabled">0 {translate key="common.queue.short.submissionsInReview"}</span>
						{/if}
					</td>
          <td>
            {if $directorSubmissionsCount[2]}
              <a href="{url conference=$conferencePath schedConf=$schedConfPath  page="director" op="submissions" path="submissionsAccepted"}">{$directorSubmissionsCount[2]} {translate key="common.queue.short.submissionsAccepted"}</a>
            {else}
              <span class="disabled">0 {translate key="common.queue.short.submissionsAccepted"}</span>
            {/if}
          </td>
          <td>
            {if $directorSubmissionsCount[3]}
              <a href="{url conference=$conferencePath schedConf=$schedConfPath  page="director" op="submissions" path="submissionsArchives"}">{$directorSubmissionsCount[3]} {translate key="common.queue.short.submissionsArchives"}</a>
            {else}
              <span class="disabled">0 {translate key="common.queue.short.submissionsArchives"}</span>
            {/if}
          </td>
					<td align="right"><a href="{url conference=$conferencePath schedConf=$schedConfPath  page="director" op="notifyUsers"}"><button type="button">{translate key="director.notifyUsers"}</button></a></td>
				</tr>
			{/if}
			{if $isValid.TrackDirector.$conferenceId.$schedConfId}
				{assign var="trackDirectorSubmissionsCount" value=$submissionsCount.TrackDirector.$conferenceId.$schedConfId}
				<tr>
					<td>&#187; <a href="{url conference=$conferencePath schedConf=$schedConfPath  page="trackDirector"}">{translate key="user.role.trackDirector"}</a></td>
					<td></td>
					<td colspan="4">
						{if $trackDirectorSubmissionsCount[0]}
							<a href="{url conference=$conferencePath schedConf=$schedConfPath  page="trackDirector" op="index" path="submissionsInReview"}">{$trackDirectorSubmissionsCount[0]} {translate key="common.queue.short.submissionsInReview"}</a>
						{else}
							<span class="disabled">0 {translate key="common.queue.short.submissionsInReview"}</span>
						{/if}
					</td>
				</tr>
			{/if}
			{if $isValid.Author.$conferenceId.$schedConfId || $isValid.Reviewer.$conferenceId.$schedConfId}
				<tr><td class="separator" width="100%" colspan="6">&nbsp;</td></tr>
			{/if}
			{if $isValid.Author.$conferenceId.$schedConfId}
				{assign var="authorSubmissionsCount" value=$submissionsCount.Author.$conferenceId.$schedConfId}
				<tr>
					<td colspan="2">
						&#187; <a href="{url conference=$conferencePath schedConf=$schedConfPath  page="author"}">{translate key="user.role.author"}</a>
					</td>
					{* In Review *}
					<td colspan="1">
					{if $authorSubmissionsCount[0]}
						<a href="{url conference=$conferencePath schedConf=$schedConfPath  page="author" op="index" path="active"}">{$authorSubmissionsCount[0]} {translate key="common.queue.short.active"}</a>
					{else}
						<span class="disabled">0 {translate key="common.queue.short.active"}</span>
					{/if}
					</td>
					{* Archived *}
					<td colspan="2">
					{if $authorSubmissionsCount[2]}
						<a href="{url conference=$conferencePath schedConf=$schedConfPath  page="author" op="index" path="completed"}">{$authorSubmissionsCount[2]} {translate key="common.queue.short.submissionsArchives"}</a>
					{else}
						<span class="disabled">0 {translate key="common.queue.short.submissionsArchives"}</span>
					{/if}
					</td>

					<td align="right">
						<a href="{url conference=$conferencePath schedConf=$schedConfPath  page="author" op="submit"}">
							<button type="button">{translate key="author.submit"}</button>
						</a>
					</td>
				</tr>
			{/if}
			{if $isValid.Reviewer.$conferenceId.$schedConfId}
				{assign var="reviewerSubmissionsCount" value=$submissionsCount.Reviewer.$conferenceId.$schedConfId}
				<tr>
					<td colspan="3">&#187; <a href="{url conference=$conferencePath schedConf=$schedConfPath  page="reviewer"}">{translate key="user.role.reviewer"}</a></td>
					<td colspan="3">
            {if $reviewerSubmissionsCount[0]}
							<a href="{url conference=$conferencePath schedConf=$schedConfPath  page="reviewer"}">{$reviewerSubmissionsCount[0]} {translate key="common.queue.short.active"}</a>
						{else}<span class="disabled">0 {translate key="common.queue.short.active"}</span>{/if}
					</td>
				</tr>
			{/if}
			
			{* Add a row to the bottom of each table to ensure all have same width*}
			<tr>
				<td width="25%"></td>
				<td width="14%"></td>
				<td width="14%"></td>
				<td width="14%"></td>
				<td width="14%"></td>
        <td width="19%"></td>
			</tr>

		</table>
	</div>
	{/foreach}

	{call_hook name="Templates::User::Index::Conference" conference=$conference}
	</div>
{/foreach}
{*$hasRole*}
{if !$hasRole}
	{if !$currentSchedConf}
		<p>{translate key="user.noRoles.chooseConference"}</p>
		{foreach from=$allConferences item=thisConference key=conferenceId}
			<h4>{$thisConference->getConferenceTitle()|escape}</h4>
			{if !empty($allSchedConfs[$conferenceId])}
			<ul class="plain">
			{foreach from=$allSchedConfs[$conferenceId] item=thisSchedConf key=schedConfId}
				<li>&#187; <a href="{url conference=$thisConference->getPath() schedConf=$thisSchedConf->getPath() page="user" op="index"}">{$thisSchedConf->getSchedConfTitle()|escape}</a></li>
			{/foreach}
			</ul>
			{/if}{* !empty($allSchedConfs[$conferenceId]) *}
		{/foreach}
	{else}{* !$currentSchedConf *}
		{url|assign:"sourceUrl" page="user"}
		<p>{translate key="user.noRoles.noRolesForConference"}</p>
		<ul class="plain">
			<li>
				&#187;
				{if $allowRegAuthor}
					<a href="{url schedConf="2018" page="user" op="become" path="author" source=$sourceUrl}">{translate key="user.noRoles.regAuthor" schedConfTitle=$currentSchedConf->getSchedConfTitle()|escape}</a>
				{else}{* $allowRegAuthor *}
					{translate key="user.noRoles.regAuthorClosed"}
				{/if}{* $allowRegAuthor *}
			</li>
				{*<li>
				&#187;
				{if $allowRegReviewer}
					{url|assign:"userHomeUrl" page="user" op="index"}
					<a href="{url op="become" schedConf="2018" path="reviewer" source=$userHomeUrl}">{translate key="user.noRoles.regReviewer"}</a>
				{else}
					{translate key="user.noRoles.regReviewerClosed"}
				{/if}
			</li>*}
			<li>
				&#187;
				{if $schedConfPaymentsEnabled}
					<a href="{url page="schedConf" schedConf="2018" op="registration"}">{translate key="user.noRoles.register"}</a>
				{else}{* $schedConfPaymentsEnabled *}
					{translate key="user.noRoles.registerUnavailable"}
				{/if}{* $schedConfPaymentsEnabled *}
			</li>
		</ul>
	{/if}{* !$currentSchedConf *}
{/if}

<div id="myAccount">
<h3>{translate key="user.myAccount"}</h3>
<p>{translate key="user.specificSymbol"}: <strong>{$userId}</strong></p>

<ul class="plain">
	{if $hasOtherConferences}
		{if !$showAllConferences}
			<li>&#187; <a href="{url conference="index" page="user"}">{translate key="user.showAllConferences"}</a></li>
		{/if}
	{/if}
  	{if $schedConfPostPayment}<li>&#187; <a href="{url page="schedConf" schedConf=$currentSchedConf->getPath() op="registration"}">{translate key="schedConf.registration"}</a></li>{/if}
	<li>&#187; <a href="{url page="user" schedConf=$currentSchedConf->getPath() op="profile"}">{translate key="user.editMyProfile"}</a></li>
	<li>&#187; <a href="{url page="user" op="changePassword"}">{translate key="user.changeMyPassword"}</a></li>
	<li>&#187; <a href="{url page="login" op="signOut"}">{translate key="user.logOut"}</a></li>
	{call_hook name="Templates::User::Index::MyAccount"}
</ul>
</div>

{include file="common/footer.tpl"}
