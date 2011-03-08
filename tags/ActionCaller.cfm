<cfparam name="attributes.action" type="string" />
<cfparam name="attributes.type" type="string" default="link">
<cfparam name="attributes.querystring" type="string" default="" />
<cfparam name="attributes.text" type="string" default="">
<cfparam name="attributes.title" type="string" default="">
<cfparam name="attributes.class" type="string" default="">
<cfparam name="attributes.confirmrequired" type="boolean" default="false" />
<cfparam name="attributes.confirmtext" type="string" default="" />
<cfparam name="attributes.disabled" type="boolean" default="false" />
<cfparam name="attributes.disabledtext" type="string" default="" />

<cfset variables.fw = caller.this />

<cfset attributes.class = Replace(Replace(attributes.action, ":", "", "all"), ".", "", "all") & " " & attributes.class />

<cfif attributes.text eq "">
	<cfset attributes.text = request.customMuraScopeKeys.slatwall.rbKey("#Replace(attributes.action, ":", ".", "all")#_nav") />
	<cfif right(attributes.text, 8) eq "_missing" >
		<cfset attributes.text = request.customMuraScopeKeys.slatwall.rbKey("#Replace(attributes.action, ":", ".", "all")#") />
	</cfif>
</cfif>

<cfif attributes.title eq "">
	<cfset attributes.title = request.customMuraScopeKeys.slatwall.rbKey("#Replace(attributes.action, ":", ".", "all")#_title") />
	<cfif right(attributes.title, 8) eq "_missing" >
		<cfset attributes.title = request.customMuraScopeKeys.slatwall.rbKey("#Replace(attributes.action, ":", ".", "all")#") />
	</cfif>
</cfif>

<cfif attributes.disabled is true>
    <cfif trim(attributes.disabledtext) eq "">
       <cfset attributes.disabledtext = request.customMuraScopeKeys.slatwall.rbKey("#Replace(attributes.action, ":", ".", "all")#_disabled") />
	</cfif>
	<cfset attributes.class &= "Off" />
</cfif>

<cfif attributes.confirmrequired is true>
    <cfif trim(attributes.confirmtext) eq "">
       <cfset attributes.confirmtext = request.customMuraScopeKeys.slatwall.rbKey("#Replace(attributes.action, ":", ".", "all")#_confirm") />
	</cfif>
</cfif>

<cfif thisTag.executionMode is "start">
	<cfif variables.fw.secureDisplay(action=attributes.action)>
		<cfif attributes.type eq "link">
			<cfoutput><a href="#variables.fw.buildURL(action=attributes.action,querystring=attributes.querystring)#" title="#attributes.title#" class="#attributes.class#"<cfif attributes.disabled> onclick="return alertDialog('#attributes.disabledtext#');"<cfelseif attributes.confirmrequired> onclick="return confirmDialog('#attributes.confirmtext#',this.href);"</cfif>>#attributes.text#</a></cfoutput>
		<cfelseif attributes.type eq "list">
			<cfoutput><li class="#attributes.class#"><a href="#variables.fw.buildURL(action=attributes.action,querystring=attributes.querystring)#" title="#attributes.title#" class="#attributes.class#"<cfif attributes.disabled> onclick="return alertDialog('#attributes.disabledtext#');"<cfelseif attributes.confirmrequired> onclick="return confirmDialog('#attributes.confirmtext#',this.href);"</cfif>>#attributes.text#</a></li></cfoutput> 
		<cfelseif attributes.type eq "button">
			<cfoutput><button type="button" class="#attributes.class#" name="slatAction" value="#attributes.action#" title="#attributes.title#"<cfif attributes.disabled> onclick="return alertDialog('#attributes.disabledtext#');"<cfelseif attributes.confirmrequired> onclick="return btnConfirmDialog('#attributes.confirmtext#',this);"</cfif>>#attributes.text#</button></cfoutput>
		<cfelseif attributes.type eq "submit">
			<cfoutput><button type="submit" class="#attributes.class#" name="slatAction" value="#attributes.action#" title="#attributes.title#"<cfif attributes.disabled> onclick="return alertDialog('#attributes.disabledtext#');"<cfelseif attributes.confirmrequired> onclick="return btnConfirmDialog('#attributes.confirmtext#',this);"</cfif>>#attributes.text#</button></cfoutput>
		</cfif>
	</cfif>
</cfif>