//
//  Torch.js
//  PhoneGap Plugin
//
//  Only supported in iOS4, and flash capable device (currently iPhone 4 only)
//
// Created by Shazron Abdullah May 26th 2011
//

function Torch()
{
	this._isOn = false;
	var self = this;
	
	this.__defineGetter__("isOn", function() { return self._isOn; });	
}

Torch.prototype.turnOn = function()
{
	cordova.exec(function(){}, function(){}, 'Torch', 'turnOn', []);
};

Torch.prototype.turnOff = function()
{
	cordova.exec(function(){}, function(){}, 'Torch', 'turnOff', []);
};

Torch.install = function()
{
	if(!window.plugins) {
		window.plugins = {};
	}
	window.plugins.torch = new Torch();
};

cordova.addConstructor(Torch.install);