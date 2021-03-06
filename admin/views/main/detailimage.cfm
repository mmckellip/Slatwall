<!---

    Slatwall - An Open Source eCommerce Platform
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
<cfparam name="rc.image" type="any" />
<cfparam name="rc.directory" type="any" default="" />
<cfparam name="rc.edit" type="boolean" default="false" />

<cfparam name="rc.productID" type="string" default="" />
<cfparam name="rc.promotionID" type="string" default="" />

<cfif !isNull(rc.image.getDirectory())>
	<cfset rc.directory = rc.image.getDirectory() />
</cfif>
<cfif !isNull(rc.image.getProduct())>
	<cfset rc.productID = rc.image.getProduct().getProductID() />
</cfif>
<cfif !isNull(rc.image.getPromotion())>
	<cfset rc.promotionID = rc.image.getPromotion().getPromotionID() />
</cfif>	

<cfoutput>
	<cf_SlatwallDetailForm object="#rc.image#" edit="#rc.edit#" enctype="multipart/form-data">
		<cf_SlatwallActionBar type="detail" object="#rc.image#" edit="#rc.edit#"></cf_SlatwallActionBar>
		
		<input type="hidden" name="directory" value="#rc.directory#" />
		<input type="hidden" name="product.productID" value="#rc.productID#" />
		<input type="hidden" name="promotion.promotionID" value="#rc.promotionID#" />
		
		<cf_SlatwallDetailHeader>
			<cf_SlatwallPropertyList>
				<cf_SlatwallPropertyDisplay object="#rc.image#" property="imageName" edit="#rc.edit#">
				<cf_SlatwallPropertyDisplay object="#rc.image#" property="imageDescription" edit="#rc.edit#">
				<cf_SlatwallPropertyDisplay object="#rc.image#" property="imageType" edit="#rc.edit#">
				<cf_SlatwallPropertyDisplay object="#rc.image#" property="imageFile" edit="#rc.edit#" fieldtype="file">
				<cfif not rc.image.isNew()>
					<div class="control-group">
						<label class="control-label">&nbsp;</label>
						<div class="controls">
							<img src="#rc.image.getResizedImagePath(width="200",height="200")#" border="0" /><br />
						</div>
					</div>
				</cfif>
			</cf_SlatwallPropertyList>
		</cf_SlatwallDetailHeader>
		
	</cf_SlatwallDetailForm>

</cfoutput>