/*

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

*/
component displayname="Promotion Reward" entityname="SlatwallPromotionReward" table="SlatwallPromotionReward" persistent="true" extends="BaseEntity" discriminatorColumn="rewardType" {
	
	// Persistent Properties
	property name="promotionRewardID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="percentageOff" ormType="big_decimal";
	property name="amountOff" ormType="big_decimal";
	property name="amount" ormType="big_decimal" hint="can't apply to order rewards";
	
	// Related Object Properties (many-to-one)
	property name="promotionPeriod" cfc="PromotionPeriod" fieldtype="many-to-one" fkcolumn="promotionPeriodID";
	
	// Special Related Discriminator Property
	property name="rewardType" length="255" insert="false" update="false";
	
	// Remote Properties
	property name="remoteID" ormtype="string";
	
	// Audit properties
	property name="createdDateTime" ormtype="timestamp";
	property name="createdByAccount" cfc="Account" fieldtype="many-to-one" fkcolumn="createdByAccountID";
	property name="modifiedDateTime" ormtype="timestamp";
	property name="modifiedByAccount" cfc="Account" fieldtype="many-to-one" fkcolumn="modifiedByAccountID";

	// Non-persistent entities
	property name="discountType" persistent="false";
	property name="discount" persistent="false" type="string"; 
	property name="rewardTypeDisplay" persistent="false";
	property name="rewardItems" type="string" persistent="false";
	
	/******* Association management methods for bidirectional relationships **************/
	
	// Promotion Period (many-to-one)
	
	public void function setPromotionPeriod(required promotionPeriod promotionPeriod) {
		variables.promotionPeriod = arguments.promotionPeriod;
		if(!arguments.promotionPeriod.hasPromotionReward(this)) {
			arrayAppend(arguments.promotionPeriod.getPromotionRewards(),this);
		}
	}
	
	public void function removePromotionPeriod(PromotionPeriod promotionPeriod) {
	   if(!structKeyExists(arguments,"promotionPeriod")) {
	   		arguments.promotionPeriod = variables.promotionPeriod;
	   }
       var index = arrayFind(arguments.promotionPeriod.getPromotionRewards(),this);
       if(index > 0) {
           arrayDeleteAt(arguments.promotionPeriod.getPromotionRewards(), index);
       }
       structDelete(variables,"promotionPeriod");
    }
    
    /************   END Association Management Methods   *******************/

	public boolean function hasValidPercentageOffValue() {
		if(getDiscountType() == "percentageOff" && ( isNull(getPercentageOff()) || !isNumeric(getPercentageOff()) || getPercentageOff() > 100 || getPercentageOff() < 0 ) ) {
			return false;
		}
		return true;
	}
	
	public boolean function hasValidAmountOffValue() {
		if(getDiscountType() == "amountOff" && ( isNull(getAmountOff()) || !isNumeric(getAmountOff()) ) ) {
			return false;
		}
		return true;
	}
	
	public boolean function hasValidAmountValue() {
		if(getDiscountType() == "amount" && ( isNull(getAmount()) || !isNumeric(getAmount()) ) ) {
			return false;
		}
		return true;
	}
	
	public string function getSimpleRepresentation() {
		return getPromotionPeriod().getPromotion().getPromotionName();
	}

	// ============ START: Non-Persistent Property Methods =================

	
	public string function getDiscountType() {
		if(isNull(variables.DiscountType)) {
			if(!isNull(getPercentageOff()) && isNull(getAmountOff()) && isNull(getAmount())) {
				variables.DiscountType = "percentageOff";
			} else if (!isNull(getAmountOff()) && isNull(getPercentageOff()) && isNull(getAmount())) {
				variables.DiscountType = "amountOff";
			} else if (!isNull(getAmount()) && isNull(getPercentageOff()) && isNull( getAmountOff())) {
				variables.DiscountType = "amount";
			} else {
				variables.DiscountType = "percentageOff";
			}
		}
		return variables.DiscountType;
	}	
	
	public string function getDiscount() {
		if( !structKeyExists(variables,"discount") ) {
			if( getDiscountType() == "percentageOff" ) {
				variables.discount = getPercentageOff() & " " & rbKey('entity.promotionReward.discountType.percentageOffShort');
			} else if( getDiscountType() == "amountOff" ) {
				variables.discount = formatValue( getAmountOff(),"currency" ) & " " & rbKey('entity.promotionReward.discountType.amountOffShort');
			} else if( getDiscountType() == "amount" ) {
				variables.discount = formatValue( getAmount(),"currency" ) & " " & rbKey('entity.promotionReward.discountType.amountShort');
			}
		}
		return variables.discount;
	}
	
	public string function getRewardTypeDisplay() {
		return rbKey( "entity.promotionReward.rewardType." & getRewardType() );
	}
	
	public string function getRewardItems() {
		if( !structKeyExists( variables,"rewardItems" ) ) {
			variables.rewardItems = "";
			if( getRewardType() eq "product" ) {
				var items = "";
				if( arrayLen(getSkus()) ) {
					items &= "<p>";
					items &= rbKey('entity.promotionRewardProduct.skus') & ": ";
					items &= displaySkuCodes();
					items &= "</p>";
				}
				if( arrayLen(getProducts()) ) {
					items &= "<p>";
					items &= rbKey('entity.promotionRewardProduct.products') & ": ";
					items &= displayProductNames();
					items &= "</p>";
				}
				if( arrayLen(getProductTypes()) ) {
					items &= "<p>";
					items &= $.Slatwall.rbKey('entity.promotionRewardProduct.productTypes') & ": ";
					items &= displayProductTypeNames();
					items &= "</p>";
				}
				if( arrayLen(getBrands()) ) {
					items &= "<p>";
					items &= $.Slatwall.rbKey('entity.promotionRewardProduct.brands') & ": ";
					items &= displayBrandNames();
					items &= "</p>";
				}
				if( arrayLen(getOptions()) ) {
					items &= "<p>";
					items &= $.Slatwall.rbKey('entity.promotionRewardProduct.options') & ": ";
					items &= displayOptionNames();
					items &= "</p>";
				}
				if( len(items) == 0 ) {
					items &= "<p>";
					items &= $.Slatwall.rbKey("define.all");
					items &= "</p>";
				}
			} else if( getRewardType() == "shipping" ) {
				if( arrayLen(getShippingMethods()) ) {
					items = displayShippingMethodNames();
				} else {
					items = $.Slatwall.rbKey("define.all");
				}
			} else if( getRewardType() == "order" ) {
				items = $.Slatwall.rbKey("define.na");
			}
			variables.rewardItems = items;	
		}
		return variables.rewardItems;
	}
	
	// ============  END:  Non-Persistent Property Methods =================
		
	// ============= START: Bidirectional Helper Methods ===================
	
	// =============  END:  Bidirectional Helper Methods ===================

	public array function getDiscountTypeOptions() {
		return [
			{name=rbKey("admin.pricing.promotionreward.discountType.percentageOff"), value="percentageOff"},
			{name=rbKey("admin.pricing.promotionreward.discountType.amountOff"), value="amountOff"},
			{name=rbKey("admin.pricing.promotionreward.discountType.amount"), value="amount"}
		];
	}
	
	// =================== START: ORM Event Hooks  =========================
	
	// ===================  END:  ORM Event Hooks  =========================
}