<!---

    Slatwall - An e-commerce plugin for Mura CMS
    Copyright (C) 2011 ten24, LLC

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
    
    Linking this library statically or dynamically with other modules is
    making a combined work based on this library.  Thus, the terms and
    conditions of the GNU General Public License cover the whole
    combination.
 
    As a special exception, the copyright holders of this library give you
    permission to link this library with independent modules to produce an
    executable, regardless of the license terms of these independent
    modules, and to copy and distribute the resulting executable under
    terms of your choice, provided that you also meet, for each linked
    independent module, the terms and conditions of the license of that
    module.  An independent module is a module which is not derived from
    or based on this library.  If you modify this library, you may extend
    this exception to your version of the library, but you are not
    obligated to do so.  If you do not wish to do so, delete this
    exception statement from your version.

Notes:

--->
<cfparam name="rc.cartSmartList" type="any" />


<cfoutput>
	
<ul id="navTask">
    <cf_SlatwallActionCaller action="admin:order.list" type="list">
</ul>

<div class="svoadmincartlist">
	
	
	<table id="CartList" class="stripe">
		<tr>
			<th>#rc.$.Slatwall.rbKey("entity.order.createdDateTime")#</th>
			<th class="varWidth">#rc.$.Slatwall.rbKey("entity.account.fullName")#</th>
			<th>#rc.$.Slatwall.rbKey("entity.order.total")#</th>
			<th>&nbsp</th>
		</tr>
		<cfloop array="#rc.cartSmartList.getPageRecords()#" index="local.order">
			<tr>
				<td>#DateFormat(Local.Order.getCreatedDateTime(), "medium")#</td>
				<td class="varWidth">
					#Local.Order.getAccount().getFullName()# <cfif local.order.getAccount().isGuestAccount()>(#$.slatwall.rbKey('admin.order.account.isguestaccount')#)</cfif>
				</td>
				<td>#DollarFormat(local.order.getTotal())#</td>
				<td class="administration">
					<ul class="one">
					  <cf_SlatwallActionCaller action="admin:order.detailcart" querystring="orderID=#local.order.getOrderID()#" class="viewDetails" type="list">
					</ul>     						
				</td>
			</tr>
		</cfloop>
	</table>
	<cf_SlatwallSmartListPager smartList="#rc.cartSmartList#">
</div>
</cfoutput>