# ZLib

|Links||
|---|---|
|Discord|https://discord.gg/bfrhABD|
|Curseforge|https://wow.curseforge.com/projects/zlib|

## Contents

|[Helper Functions](#helper-functions)|
|---|

|[Simple Objects](#simple-objects)||
|---|---|
|[Button](#button)|[CheckBox](#checkbox)|
|[Dropdown](#dropdown)|[EditBox](#editbox)|
|[Frame](#frame)|[Heading](#heading)|
|[InteractiveLabel](#interactivelabel)|[Label](#label)|
|[Slider](#slider)||

|[Complex Objects](#complex-objects)||
|---|---|
|[DatePicker](#datepicker)|[DateTimePicker](#datetimepicker)|
|[Table](#table)|[TimePicker](#timepicker)|

## Helper Functions
|[Back To Top](#zlib)|
|---|

|Helper Functions|Parameters|Description|
|---|---|---|
|```ZLib:IsDateValid(oDate)```|```oDate``` = date object, such as returned by ```date("*t")```| Returns true if the oDate argument is in the appropriate format and is a valid date.  Checks the ```year```, ```month```, and ```day``` properties.|
|```ZLib:IsTimeValid(oTime)```|```oTime``` = time object, such as returned by ```date("*t")```| Returns true if the oTime argument is in teh appropriate format and is a valid time.  Checks the ```hour```, ```min```, and ```sec``` properties.|
|```ZLib:IsDateTimeValid(oDateTime)```|```oDateTime``` = date/time object, such as returned by ```date("*t")```| Returns true if the oDateTime argument passes ```ZLib:IsValidDate(oDateTime)``` and ```ZLib:IsValidTime(oDateTime)``` tests.|
|```ZLib:IsTableValid(oTable)```|```oTable``` = a variable that you wish to test | Returns true if the ```oTable``` argument is not nil and has a type of table.|
|```ZLib:IsNumberValid(iNumber)```|```iNumber``` = a value to test.|```Returns true if ```iNumber``` is not nil and ```tonumber(iNumber)``` is not nil.  *Note:* This will validate both numbers and numeric strings.
|```ZLib:IsStringValid(sText)```|```sText``` = a value to test.|```Returns true if ```sText``` is not nil and contains characters other than spaces.|
|```ZLib:Trim(sText)```|```sText``` = variable to edit.|```Returns ```sText``` with all leading and trailing spaces removed.|
|```ZLib:CreateIntegerList(iMin,iMax)```|```iMin``` = minimum value of the list.<br/>```iMax``` = maximum value of the list.|Creates a list of whole numbers between and including ```iMin``` and ```iMax```|
|```ZLib:MakeTooltip(sLink[,sAnchor])```|```sLink``` = the link text to the tooltip's data source.<br/>```sAnchor``` *OPTIONAL* = The anchor for the tooltip.  Defaults to ```"ANCHOR_CURSOR"```.|Creates a tooltip.|
|```ZLib:ClearTooltip()```||Clears the current tooltip.|
|```ZLib:GetFullName(sName)```|```sName``` = name of the player.|Returns a unit name in name-realm format.|
|```ZLib:GetMatch(aTable,value[,sProperty])```|```aTable``` = The collection of values that may contain a match.<br/>```value``` = Value for which you are looking.<br/>```sProperty``` *OPTIONAL* = the name of the property to check against the ```value``` argument.  Required for assosiative arrays.|Returns the value of the first match.|

## Simple Objects
|[Back To Top](#zlib)|
|---|

### Button
|[Back To Top](#zlib)|
|---|

Constructor: ZLib.Button:new(AceGUI,dWidth,sText,oCallbacks)
This is a single button that executes it's OnClick event when the button is clicked.

#### Arguments
|Argument|Type|Description|
|---|---|---|
|AceGUI|object|An instance of LibStub("AceGUI-3.0").|
|dWidth|decimal|A decimal value that represents the relative width of the control within it's parent row.|
|sText|string|The text that appears on the button.|
|oCallbacks|object|An object that defines the OnClick, OnEnter, and OnLeave callbacks.|

#### oCallbacks
##### OnClick
Stub: function(control)

|Arguments|Type|Description|
|---|---|---|
|control|object|A reference to the control that called this callback.|

##### OnEnter (Optional)
Stub: function(control)

|Arguments|Type|Description|
|---|---|---|
|control|object|A reference to the control that called this callback.|

##### OnLeave (Optional)
Stub: function(control)

|Arguments|Type|Description|
|---|---|---|
|control|object|A reference to the control that called this callback.|

### CheckBox
|[Back To Top](#zlib)|
|---|

Constructor: ZLib.CheckBox:new(AceGUI,dWidth,bDefaultValue,oCallbacks)

#### Arguments
|Argument|Type|Description|
|---|---|---|
|AceGUI|object|An instance of LibStub("AceGUI-3.0").|
|dWidth|decimal|A decimal value that represents the relative width of the control within it's parent row.|
|bDefaultValue|boolean|A boolean value to set whether or not the checkbox is checked.|
|oCallbacks|object|An object that defines the OnValueChanged, OnEnter, and OnLeave callbacks.|

#### oCallbacks
##### OnValueChanged
Stub: function(control,_,value)

|Arguments|Type|Description|
|---|---|---|
|control|object|A reference to the control that called this callback.|
|_|?|Unknown|
|value|boolean|The new value of the control.

##### OnEnter (Optional)
Stub: function(control)

|Arguments|Type|Description|
|---|---|---|
|control|object|A reference to the control that called this callback.|

##### OnLeave (Optional)
Stub: function(control)

|Arguments|Type|Description|
|---|---|---|
|control|object|A reference to the control that called this callback.|

### Dropdown
|[Back To Top](#zlib)|
|---|

Constructor: ZLib.Dropdown:new(AceGUI,dWidth,oOptions,oCallbacks)

#### Arguments
|Argument|Type|Description|
|---|---|---|
|AceGUI|object|An instance of LibStub("AceGUI-3.0").|
|dWidth|decimal|A decimal value that represents the relative width of the control within it's parent row.|
|oOptions|object|An object containing the data for the control.|
|oCallbacks|object|An object that defines the OnValueChanged, OnEnter, and OnLeave callbacks.|

#### oOptions
|Property|Type|Description|
|---|---|---|
|Values|object|An object containing the key-value pairs that define the options in the dropdown.|
|ValuesOrder|array|A single-dimension array of keys from the Values object that determines the order in which the options should be listed.|
|DefaultValue|any|The default value from the Values object that should be selected when the control is created.|

#### oCallbacks
##### OnValueChanged
Stub: function(control,_,value)

|Arguments|Type|Description|
|---|---|---|
|control|object|A reference to the control that called this callback.|
|_|?|Unknown|
|value|boolean|The new value of the control.

##### OnEnter (Optional)
Stub: function(control)

|Arguments|Type|Description|
|---|---|---|
|control|object|A reference to the control that called this callback.|

##### OnLeave (Optional)
Stub: function(control)

|Arguments|Type|Description|
|---|---|---|
|control|object|A reference to the control that called this callback.|

### EditBox
|[Back To Top](#zlib)|
|---|

Constructor: ZLib.EditBox:new(AceGUI,dWidth,sDefaultValue,oCallbacks)

|Argument|Type|Description|
|---|---|---|
|AceGUI|object|An instance of LibStub("AceGUI-3.0").|
|dWidth|decimal|A decimal value that represents the relative width of the control within it's parent row.|
|sDefaultValue|string|The text the editbox will contain when it is created.|
|oCallbacks|object|An object that defines the OnEnterPressed, OnEnter, and OnLeave callbacks.|

#### oCallbacks
##### OnEnterPressed
Stub: function(control,_,value)

|Arguments|Type|Description|
|---|---|---|
|control|object|A reference to the control that called this callback.|
|_|?|Unknown|
|value|boolean|The new value of the control.

##### OnEnter (Optional)
Stub: function(control)

|Arguments|Type|Description|
|---|---|---|
|control|object|A reference to the control that called this callback.|

##### OnLeave (Optional)
Stub: function(control)

|Arguments|Type|Description|
|---|---|---|
|control|object|A reference to the control that called this callback.|

### Frame
|[Back To Top](#zlib)|
|---|

Constructor: ZLib.Frame:new(AceGUI,sLayout,sTitle)

|Argument|Type|Description|
|---|---|---|
|AceGUI|object|An instance of LibStub("AceGUI-3.0").|
|sLayout|string|A string value for the layout of the frame.  Options include "Flow" (Left-to-Right), "List" (top-to-bottom) and "Fill" (first control uses entire frame).|
|sDefaultValue|string|The text the editbox will contain when it is created.|
|oCallbacks|object|An object that defines the OnEnterPressed, OnEnter, and OnLeave callbacks.|

#### Functions
In addition to the normal Ace3 functions, this control also supports the following functions.
##### Toggle
Syntax: frame:Toggle();\
Automatically toggles the visibility of the frame.

### Heading
|[Back To Top](#zlib)|
|---|

Constructor: ZLib.Heading:new(AceGUI,dWidth,sText)

|Argument|Type|Description|
|---|---|---|
|AceGUI|object|An instance of LibStub("AceGUI-3.0").|
|dWidth|decimal|A decimal value that represents the relative width of the control within it's parent row.|
|sText|string|The text of the heading.|

### InteractiveLabel
|[Back To Top](#zlib)|
|---|

Constructor: ZLib.InteractiveLabel:new(AceGUI,dWidth,sText,oCallbacks)

|Argument|Type|Description|
|---|---|---|
|AceGUI|object|An instance of LibStub("AceGUI-3.0").|
|dWidth|decimal|A decimal value that represents the relative width of the control within it's parent row.|
|sText|string|The text of the control.|
|oCallbacks|object|An object that defines the OnClick, OnEnter, and OnLeave callbacks.|

#### oCallbacks
##### OnClick
Stub: function(control)

|Arguments|Type|Description|
|---|---|---|
|control|object|A reference to the control that called this callback.|

##### OnEnter (Optional)
Stub: function(control)

|Arguments|Type|Description|
|---|---|---|
|control|object|A reference to the control that called this callback.|

##### OnLeave (Optional)
Stub: function(control)

|Arguments|Type|Description|
|---|---|---|
|control|object|A reference to the control that called this callback.|

### Label
|[Back To Top](#zlib)|
|---|

Constructor: ZLib.Label:new(AceGUI,dWidth,sText)

|Argument|Type|Description|
|---|---|---|
|AceGUI|object|An instance of LibStub("AceGUI-3.0").|
|dWidth|decimal|A decimal value that represents the relative width of the control within it's parent row.|
|sText|string|The text of the control.|

### Slider
|[Back To Top](#zlib)|
|---|

Constructor: ZLib.Slider:new(AceGUI,dWidth,oOptions,oCallbacks)

|Argument|Type|Description|
|---|---|---|
|AceGUI|object|An instance of LibStub("AceGUI-3.0").|
|dWidth|decimal|A decimal value that represents the relative width of the control within it's parent row.|
|oOptions|object|An object containing the data for the control.|
|oCallbacks|object|An object that defines the OnValueChanged callback.|

#### oOptions
|Property|Type|Description|
|---|---|---|
|Min|number|The minimum value the slider can represent.|
|Max|number|The maximum value the slider can represent.|
|Step|number|The amount of increment for each step of the slider.|
|DefaultValue|number|The value of the slider when the control is created.|

#### oCallbacks
##### OnValueChanged
Stub: function(control,_,value)

|Arguments|Type|Description|
|---|---|---|
|control|object|A reference to the control that called this callback.|
|_|?|Unknown|
|value|boolean|The new value of the control.|


## Complex Objects
|[Back To Top](#zlib)|
|---|

### DatePicker
|[Back To Top](#zlib)|
|---|

Constructor: ZLib.DatePicker:new(AceGUI,dWidth,oOptions,oCallbacks)

|Argument|Type|Description|
|---|---|---|
|AceGUI|object|An instance of LibStub("AceGUI-3.0").|
|dWidth|decimal|A decimal value that represents the relative width of the control within it's parent row.|
|oOptions|object|An object containing the data for the control.|
|oCallbacks|object|An object that defines the OnValueChanged callback.|

#### oOptions
|Property|Type|Description|
|---|---|---|
|MinYear|number|The minimum year the datepicker will allow.|
|MaxYear|number|The maximum value the slider can represent.|
|DefaultValue|object|The date object ({ year: 1990, month: 2, day: 10 }) representing the value the control should have when it is created.|

#### oCallbacks
##### OnValueChanged
Stub: function(control,oDate,sPropertyChanged,iValue)

|Arguments|Type|Description|
|---|---|---|
|control|object|A reference to the control that called this callback.|
|oDate|object|A date object representing the new value of the control.|
|sPropertyChanged|string|The date component that changed.  Possible values are "year", "month", or "day".|
|iValue|integer|The new value of the property that was changed.|
|sError|string|The error message of there is one, otherwise, nil.|

#### Functions
##### GetValue
Syntax: datePicker:GetValue();\
Returns the date object value of the DatePicker.

##### SetValue
Syntax: datePicker:SetValue(oDate);

|Arguments|Type|Description|
|---|---|---|
|oDate|object|A date object value that represents the intended date for the date picker.|




### DateTimePicker
|[Back To Top](#zlib)|
|---|

### Table
|[Back To Top](#zlib)|
|---|

### TimePicker
|[Back To Top](#zlib)|
|---|

Constructor: ZLib.DatePicker:new(AceGUI,dWidth,oOptions,oCallbacks)

|Argument|Type|Description|
|---|---|---|
|AceGUI|object|An instance of LibStub("AceGUI-3.0").|
|dWidth|decimal|A decimal value that represents the relative width of the control within it's parent row.|
|oOptions|object|An object containing the data for the control.|
|oCallbacks|object|An object that defines the OnValueChanged callback.|

#### oOptions
|Property|Type|Description|
|---|---|---|
|DefaultValue|object|The time object ({ hour: 20, min: 14, sec: 44 }) representing the value the control should have when it is created.|

#### oCallbacks
##### OnValueChanged
Stub: function(control,oTime,sPropertyChanged,iValue)

|Arguments|Type|Description|
|---|---|---|
|control|object|A reference to the control that called this callback.|
|oTime|object|A time object representing the new value of the control.|
|sPropertyChanged|string|The date component that changed.  Possible values are "year", "month", or "day".|
|iValue|integer|The new value of the property that was changed.|
|sError|string|The error message of there is one, otherwise, nil.|

#### Functions
##### GetValue
Syntax: timepicker:GetValue();\
Returns the date object value of the TimePicker.

##### SetValue
Syntax: timepicker:SetValue(oTime);

|Arguments|Type|Description|
|---|---|---|
|oTime|object|A time object value that represents the intended time for the time picker.|
