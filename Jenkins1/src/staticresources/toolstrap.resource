/* Font Stacks */
/* Baselines */
/* Font Weights */
/* Grids/Dimensions */
/* COLORS */
/* Border Colors */
/* Gradient Color Stops */
/* Background Colors */
/* Box/Text Shadows */
/* Tooltips */
/* Based on normalize.css (http://necolas.github.com/normalize.css/), removed fixes for non-Chrome browsers */
/* =============================================================================
 * Base
 * ========================================================================== */
/* Prevents iOS text size adjust after orientation change, without disabling user zoom
 * www.456bereastreet.com/archive/201012/controlling_text_size_in_safari_for_ios_without_disabling_user_zoom/ */
/* line 11, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/normalize.css.sass */
html {
  -webkit-text-size-adjust: 100%;
  -ms-text-size-adjust: 100%;
  overflow-y: scroll;
}

/* Addresses font-family inconsistency between 'textarea' and other form elements. */
/* line 19, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/normalize.css.sass */
html,
button,
input,
select,
textarea {
  font-family: sans-serif;
}

/* =============================================================================
 * Links
 * ========================================================================== */
/* Addresses outline displayed oddly in Chrome */
/* line 33, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/normalize.css.sass */
a:focus {
  outline: thin dotted;
}

/* Improves readability when focused and also mouse hovered in all browsers
 * people.opera.com/patrickl/experiments/keyboard/test */
/* line 40, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/normalize.css.sass */
a:hover,
a:active {
  outline: 0;
}

/* =============================================================================
 * Typography
 * ========================================================================== */
/* Addresses styling not present in IE7/8/9, S5, Chrome */
/* line 51, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/normalize.css.sass */
abbr[title] {
  border-bottom: 1px dotted;
}

/* Addresses style set to 'bolder' in FF3+, S4/5, Chrome */
/* line 57, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/normalize.css.sass */
b,
strong {
  font-weight: bold;
}

/* line 61, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/normalize.css.sass */
blockquote {
  margin: 0 40px 1em 40px;
}

/* Addresses styling not present in S5, Chrome */
/* line 67, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/normalize.css.sass */
dfn {
  font-style: italic;
}

/* Corrects font family set oddly in IE6, S4/5, Chrome
 * en.wikipedia.org/wiki/User:Davidgothberg/Test59 */
/* line 74, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/normalize.css.sass */
pre,
code,
kbd,
samp {
  font-family: monospace, serif;
  font-size: 1em;
}

/* Improves readability of pre-formatted text in all browsers */
/* line 84, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/normalize.css.sass */
pre {
  white-space: pre;
  white-space: pre-wrap;
  word-wrap: break-word;
}

/* Prevents sub and sup affecting line-height in all browsers
 * gist.github.com/413930 */
/* line 93, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/normalize.css.sass */
sub,
sup {
  font-size: 75%;
  line-height: 0;
  position: relative;
  vertical-align: baseline;
}

/* line 100, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/normalize.css.sass */
sup {
  top: -0.5em;
}

/* line 103, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/normalize.css.sass */
sub {
  bottom: -0.25em;
}

/* =============================================================================
 * Forms
 * ========================================================================== */
/* Define consistent border, margin, and padding */
/* line 112, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/normalize.css.sass */
fieldset {
  border: 1px solid silver;
  margin: 0 2px;
  padding: 0.35em 0.625em 0.75em;
}

/* 1. Corrects font size not being inherited in all browsers
 * 2. Addresses margins set differently in IE6/7, FF3+, S5, Chrome
 * 3. Improves appearance and consistency in all browsers */
/* line 122, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/normalize.css.sass */
button,
input,
select,
textarea {
  font-size: 100%;
  /* 1 */
  margin: 0;
  /* 2 */
  vertical-align: baseline;
  /* 3 */
  *vertical-align: middle;
  /* 3 */
}

/* 1. Improves usability and consistency of cursor style between image-type 'input' and others
 * 2. Corrects inability to style clickable 'input' types in iOS */
/* line 139, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/normalize.css.sass */
button,
input[type="button"],
input[type="reset"],
input[type="submit"] {
  cursor: pointer;
  /* 1 */
  -webkit-appearance: button;
  /* 2 */
}

/* Re-set default cursor for disabled elements */
/* line 151, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/normalize.css.sass */
button[disabled],
input[disabled] {
  cursor: default;
}

/* 1. Addresses appearance set to searchfield in S5, Chrome
 * 2. Addresses box-sizing set to border-box in S5, Chrome (include -moz to future-proof) */
/* line 159, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/normalize.css.sass */
input[type="search"] {
  -webkit-appearance: textfield;
  /* 1 */
  -moz-box-sizing: content-box;
  -webkit-box-sizing: content-box;
  /* 2 */
  box-sizing: content-box;
}

/* Removes inner padding and search cancel button in S5, Chrome on OS X */
/* line 170, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/normalize.css.sass */
input[type="search"]::-webkit-search-decoration,
input[type="search"]::-webkit-search-cancel-button {
  -webkit-appearance: none;
}

/* Improves readability and alignment in all browsers */
/* line 177, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/normalize.css.sass */
textarea {
  vertical-align: top;
}

/* =============================================================================
 * Tables
 * ========================================================================== */
/* Remove most spacing between table cells */
/* line 187, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/normalize.css.sass */
table {
  border-collapse: collapse;
  border-spacing: 0;
}

/* line 1, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/forms.css.sass */
.form-default {
  -webkit-border-radius: 6px;
  -moz-border-radius: 6px;
  -ms-border-radius: 6px;
  -o-border-radius: 6px;
  border-radius: 6px;
  background: #f9f9f9;
  border: 1px solid #cccccc;
  margin-bottom: 20px;
  padding: 20px;
}

/* line 8, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/forms.css.sass */
.help-text {
  color: #999999;
  font-weight: normal;
  margin: 0;
  padding-top: 5px;
}

/* line 14, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/forms.css.sass */
.control-group {
  clear: left;
  margin-bottom: 10px;
}

/* line 18, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/forms.css.sass */
.controls label {
  display: block;
}

/* line 21, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/forms.css.sass */
label {
  font-weight: bold;
  line-height: 18px;
  color: #666666;
}

/* line 26, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/forms.css.sass */
label + .controls label {
  font-weight: normal;
}

/* line 29, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/forms.css.sass */
input[type=text],
textarea,
select,
option {
  -webkit-border-radius: 3px;
  -moz-border-radius: 3px;
  -ms-border-radius: 3px;
  -o-border-radius: 3px;
  border-radius: 3px;
  -webkit-box-shadow: inset 0 1px 1px rgba(0, 0, 0, 0.075);
  -moz-box-shadow: inset 0 1px 1px rgba(0, 0, 0, 0.075);
  box-shadow: inset 0 1px 1px rgba(0, 0, 0, 0.075);
  -webkit-transition-duration: .2s, .2s, .2s;
  -moz-transition-duration: .2s, .2s, .2s;
  -ms-transition-duration: .2s, .2s, .2s;
  -o-transition-duration: .2s, .2s, .2s;
  transition-duration: .2s, .2s, .2s;
  -webkit-transition-property: border, box-shadow, outline;
  -moz-transition-property: border, box-shadow, outline;
  -ms-transition-property: border, box-shadow, outline;
  -o-transition-property: border, box-shadow, outline;
  transition-property: border, box-shadow, outline;
  background-color: white;
  border: 1px solid #cccccc;
  color: #666666;
  font-size: 13px;
  line-height: 18px;
  padding: 4px 8px;
}

/* line 44, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/forms.css.sass */
input[type=checkbox],
input[type=radio] {
  margin-right: 9px;
}

/* line 48, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/forms.css.sass */
select {
  height: 30px;
  line-height: 30px;
}

/* line 52, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/forms.css.sass */
select[multiple], select[size] {
  height: auto;
}

/* line 55, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/forms.css.sass */
fieldset {
  border: 0;
  margin: 0;
  padding: 0 0 10px 0;
}
/* line 60, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/forms.css.sass */
fieldset:last-child {
  padding-bottom: 0;
}

/* line 63, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/forms.css.sass */
legend {
  background-color: transparent;
  color: #779f46;
  font-weight: bold;
  padding: 0 0 10px 0;
}

/* line 70, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/forms.css.sass */
fieldset ~ fieldset legend + .control-group {
  margin-top: 20px;
}

/* line 73, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/forms.css.sass */
.form-actions {
  border-top: 1px solid #cccccc;
  clear: left;
  margin-top: 20px;
  padding-top: 20px;
}

/* line 79, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/forms.css.sass */
input[type=search] {
  -webkit-border-radius: 3px;
  -moz-border-radius: 3px;
  -ms-border-radius: 3px;
  -o-border-radius: 3px;
  border-radius: 3px;
  -webkit-box-sizing: content-box;
  -moz-box-sizing: content-box;
  box-sizing: content-box;
  background: white url(/assets/search.png) no-repeat 138px 8px;
  border: 1px solid #cccccc;
  height: 28px;
  padding: 0 30px 0 10px;
  width: 118px;
}

/* line 88, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/forms.css.sass */
.datepicker {
  background: url(/assets/calendar.png) no-repeat 84px 6px;
  background: url(/assets/calendar.png) no-repeat 84px 6px;
  background: url(/assets/calendar.png) no-repeat 84px 6px, -ms-linear-gradient(bottom, #dddddd 0%, #f9f9f9 100%);
  background: url(/assets/calendar.png) no-repeat 84px 6px, -webkit-gradient(linear, 0 0, 0 100%, from(#f9f9f9), to(#dddddd));
  background: url(/assets/calendar.png) no-repeat 84px 6px, -webkit-linear-gradient(bottom, #dddddd 0%, #f9f9f9 100%);
  background: url(/assets/calendar.png) no-repeat 84px 6px, -o-linear-gradient(bottom, #dddddd 0%, #f9f9f9 100%);
  background: url(/assets/calendar.png) no-repeat 84px 6px, linear-gradient(bottom, #dddddd 0%, #f9f9f9 100%);
  background: url(/assets/calendar.png) no-repeat 84px 6px, -moz-linear-gradient(bottom, #dddddd 0%, #f9f9f9 100%);
  padding-right: 30px;
  text-align: left;
}
/* line 92, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/forms.css.sass */
.datepicker:hover {
  background: url(/assets/calendar.png) no-repeat 84px 6px;
  background: url(/assets/calendar.png) no-repeat 84px 6px;
  background: url(/assets/calendar.png) no-repeat 84px 6px, -ms-linear-gradient(bottom, #dddddd 0%, #f9f9f9 100%);
  background: url(/assets/calendar.png) no-repeat 84px 6px, -webkit-gradient(linear, 0 0, 0 100%, from(#f9f9f9), to(#dddddd));
  background: url(/assets/calendar.png) no-repeat 84px 6px, -webkit-linear-gradient(bottom, #dddddd 0%, #f9f9f9 100%);
  background: url(/assets/calendar.png) no-repeat 84px 6px, -o-linear-gradient(bottom, #dddddd 0%, #f9f9f9 100%);
  background: url(/assets/calendar.png) no-repeat 84px 6px, linear-gradient(bottom, #dddddd 0%, #f9f9f9 100%);
  background: url(/assets/calendar.png) no-repeat 84px 6px, -moz-linear-gradient(bottom, #dddddd 0%, #f9f9f9 100%);
  -webkit-transition: none;
  -moz-transition: none;
  -ms-transition: none;
  -o-transition: none;
  transition: none;
}
/* line 95, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/forms.css.sass */
.datepicker:active {
  -webkit-box-shadow: inset 0 0 0 rgba(0, 0, 0, 0.15), 0 0 0 rgba(0, 0, 0, 0.05);
  -moz-box-shadow: inset 0 0 0 rgba(0, 0, 0, 0.15), 0 0 0 rgba(0, 0, 0, 0.05);
  box-shadow: inset 0 0 0 rgba(0, 0, 0, 0.15), 0 0 0 rgba(0, 0, 0, 0.05);
}

/* line 99, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/forms.css.sass */
.inline label {
  float: left;
  height: 30px;
  line-height: 30px;
  margin-right: 20px;
  min-width: 90px;
  text-align: right;
  white-space: nowrap;
}
/* line 108, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/forms.css.sass */
.inline label .control-group {
  margin-bottom: 10px;
}
/* line 111, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/forms.css.sass */
.inline label.multiline {
  line-height: 18px;
  height: 18px;
}
/* line 115, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/forms.css.sass */
.inline .controls {
  margin-left: 110px;
}
/* line 118, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/forms.css.sass */
.inline label + .controls label {
  height: 18px;
  line-height: 18px;
  text-align: left;
}
/* line 123, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/forms.css.sass */
.inline .form-actions {
  border-top: 0;
  margin-top: 0;
  padding-left: 110px;
  padding-top: 0;
}

/* line 129, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/forms.css.sass */
.no-float label {
  float: none;
}

/* line 132, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/forms.css.sass */
form hr {
  margin-top: 0;
}

/* line 135, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/forms.css.sass */
input[disabled] {
  background: #ededed;
  color: #999999;
}

/* Input sizes */
/* line 141, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/forms.css.sass */
.input-xs {
  width: 45px;
}

/* line 143, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/forms.css.sass */
.input-s {
  width: 57px;
}

/* line 145, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/forms.css.sass */
.input-m {
  width: 160px;
}

/* line 147, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/forms.css.sass */
.input-l {
  width: 312px;
}

/* line 149, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/forms.css.sass */
.input-xl {
  width: 567px;
}

/* line 151, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/forms.css.sass */
.input-full {
  width: 100%;
}

/* line 1, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/typography.css.sass */
body {
  color: #333333;
  font-family: 'Helvetica Neue', Helvetica, Arial, FreeSans, sans-serif;
  font-size: 12px;
}

/* line 6, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/typography.css.sass */
h1 {
  font-size: 30px;
  line-height: 40px;
  margin: 0 0 20px 0;
}

/* line 11, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/typography.css.sass */
h2 {
  font-size: 20px;
  line-height: 30px;
  margin: 0 0 20px 0;
}

/* line 16, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/typography.css.sass */
h3 {
  font-size: 16px;
  line-height: 20px;
  color: #779f46;
  margin: 0 0 20px 0;
}

/* line 22, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/typography.css.sass */
h4 {
  font-size: 15px;
  line-height: 1.5;
  margin: 0;
}

/* line 27, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/typography.css.sass */
h4 a {
  font-size: 11px;
  font-weight: normal;
}

/* line 31, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/typography.css.sass */
h5 {
  color: #779f46;
  font-size: 12px;
  line-height: 2;
  margin: 15px 0 0 0;
}

/* line 37, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/typography.css.sass */
h6 {
  font-size: 12px;
  line-height: 2;
  margin: 0 0 12px 0;
}

/* line 42, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/typography.css.sass */
p {
  font-size: 12px;
  line-height: 18px;
  margin: 0 0 20px 0;
}

/* line 47, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/typography.css.sass */
a {
  color: #0085c5;
  text-decoration: none;
}

/* line 51, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/typography.css.sass */
th, td {
  line-height: 18px;
}

/* line 54, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/typography.css.sass */
hr {
  border-color: #cccccc;
  border-width: 0 0 1px 0;
  clear: left;
  margin: 19px 0 20px 0;
}

/* line 60, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/typography.css.sass */
.initialism {
  font-size: 90%;
  text-transform: uppercase;
}

/* line 64, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/typography.css.sass */
.clear {
  clear: both;
}

/* line 67, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/typography.css.sass */
.unstyled {
  list-style: none;
  margin: 0;
  padding: 0;
}

/* line 1, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/modals.css.sass */
.ui-dialog {
  background-color: #fafafa;
  border-radius: 10px;
  border: 4px solid #333333;
  -webkit-box-shadow: 0 3px 7px rgba(0, 0, 0, 0.3);
  -moz-box-shadow: 0 3px 7px rgba(0, 0, 0, 0.3);
  box-shadow: 0 3px 7px rgba(0, 0, 0, 0.3);
}

/* line 7, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/modals.css.sass */
.ui-dialog-titlebar {
  background-color: #333333;
  border-bottom: 1px solid #595959;
  color: white;
}

/* line 12, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/modals.css.sass */
.ui-dialog-title {
  display: block;
  font-size: 1.17em;
  font-weight: bold;
  margin: 0;
  padding: 14px 15px;
}

/* line 19, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/modals.css.sass */
.ui-dialog-titlebar-close {
  background: url(/assets/close.png) no-repeat left top;
  cursor: pointer;
  height: 17px;
  overflow: hidden;
  position: absolute;
  right: 15px;
  text-indent: -1000px;
  top: 12px;
  width: 17px;
}

/* line 30, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/modals.css.sass */
.ui-dialog-content {
  width: 400px;
}

/* line 33, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/modals.css.sass */
.ui-widget-overlay {
  background: black;
  left: 0;
  opacity: 0.5;
  position: absolute;
  top: 0;
}

/* line 40, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/modals.css.sass */
.modal {
  padding: 20px;
}

/* line 1, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/tables.sass */
table {
  max-width: 100%;
  background-color: transparent;
  border-collapse: collapse;
  border-spacing: 0;
  margin-bottom: 20px;
}

/* line 8, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/tables.sass */
.table {
  border-collapse: separate;
  width: 100%;
}
/* line 12, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/tables.sass */
.table tbody td, .table tfoot td {
  border-top: 1px solid #e9e9e9;
}
/* line 15, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/tables.sass */
.table tbody tr:first-child td {
  border-top: 1px solid #cccccc;
}
/* line 18, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/tables.sass */
.table th, .table td {
  font-size: 12px;
  line-height: 18px;
  padding: 10px 15px;
  color: #666666;
  text-align: left;
}
/* line 24, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/tables.sass */
.table th.center, .table td.center {
  text-align: center;
}
/* line 26, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/tables.sass */
.table th.right, .table td.right {
  text-align: right;
}
/* line 29, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/tables.sass */
.table thead {
  background-image: -ms-linear-gradient(bottom, #eaebeb 0%, #fafbfb 100%);
  background-image: -webkit-gradient(linear, 0 0, 0 100%, from(#fafbfb), to(#eaebeb));
  background-image: -webkit-linear-gradient(bottom, #eaebeb 0%, #fafbfb 100%);
  background-image: -o-linear-gradient(bottom, #eaebeb 0%, #fafbfb 100%);
  background-image: linear-gradient(bottom, #eaebeb 0%, #fafbfb 100%);
  background-image: -moz-linear-gradient(bottom, #eaebeb 0%, #fafbfb 100%);
}
/* line 31, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/tables.sass */
.table thead th {
  text-shadow: 0 1px 0 white;
}
/* line 34, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/tables.sass */
.table thead th.sort-by {
  color: #f47e2b;
}
/* line 38, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/tables.sass */
.table tbody tr:hover td {
  background: #eefaff;
}

/* line 43, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/tables.sass */
.table-striped tbody tr:nth-child(odd) td, .table-striped tfoot tr:nth-child(odd) td {
  background: #fafafa;
}
/* line 45, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/tables.sass */
.table-striped tbody tr:nth-child(odd):hover td, .table-striped tfoot tr:nth-child(odd):hover td {
  background: #eefaff;
}

/* line 48, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/tables.sass */
.table-bordered, .table-bordered-horizontal {
  border: 1px solid #cccccc;
  -webkit-border-radius: 6px;
  -moz-border-radius: 6px;
  -ms-border-radius: 6px;
  -o-border-radius: 6px;
  border-radius: 6px;
}
/* line 54, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/tables.sass */
.table-bordered thead th:first-child, .table-bordered-horizontal thead th:first-child {
  -webkit-border-top-left-radius: 6px;
  -moz-border-top-left-radius: 6px;
  -ms-border-top-left-radius: 6px;
  -o-border-top-left-radius: 6px;
  border-top-left-radius: 6px;
}
/* line 56, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/tables.sass */
.table-bordered thead th:last-child, .table-bordered-horizontal thead th:last-child {
  -webkit-border-top-right-radius: 6px;
  -moz-border-top-right-radius: 6px;
  -ms-border-top-right-radius: 6px;
  -o-border-top-right-radius: 6px;
  border-top-right-radius: 6px;
}
/* line 59, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/tables.sass */
.table-bordered tfoot td:first-child, .table-bordered-horizontal tfoot td:first-child {
  -webkit-border-bottom-left-radius: 6px;
  -moz-border-bottom-left-radius: 6px;
  -ms-border-bottom-left-radius: 6px;
  -o-border-bottom-left-radius: 6px;
  border-bottom-left-radius: 6px;
}
/* line 61, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/tables.sass */
.table-bordered tfoot td:last-child, .table-bordered-horizontal tfoot td:last-child {
  -webkit-border-bottom-right-radius: 6px;
  -moz-border-bottom-right-radius: 6px;
  -ms-border-bottom-right-radius: 6px;
  -o-border-bottom-right-radius: 6px;
  border-bottom-right-radius: 6px;
}

/* line 65, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/tables.sass */
.table-bordered tbody td, .table-bordered tfoot td {
  border-left: 1px solid #e9e9e9;
}
/* line 67, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/tables.sass */
.table-bordered tbody td:first-child, .table-bordered tfoot td:first-child {
  border-left: 0;
}

/* line 70, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/tables.sass */
.table-no-outer-border {
  border: 0;
}

/* line 74, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/tables.sass */
.table-condensed th, .table-condensed td {
  padding: 5px 15px;
}

/* line 78, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/tables.sass */
.table-dashboard {
  width: 100%;
}
/* line 81, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/tables.sass */
.table-dashboard th, .table-dashboard td {
  border-left: 1px solid #cccccc;
  text-align: center;
}
/* line 85, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/tables.sass */
.table-dashboard th {
  text-transform: uppercase;
  line-height: 12px;
  font-size: 11px;
  color: #999999;
  padding: 6px 15px;
  vertical-align: top;
}
/* line 93, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/tables.sass */
.table-dashboard td {
  font-size: 18px;
  font-weight: bold;
  line-height: 18px;
  padding: 4px 28px;
  vertical-align: bottom;
}
/* line 100, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/tables.sass */
.table-dashboard th:first-of-type, .table-dashboard td:first-of-type {
  border-left: 0;
}
/* line 103, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/tables.sass */
.table-dashboard strong {
  color: #91b51b;
  font-size: 30px;
}

/* line 107, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/tables.sass */
td.caution {
  color: red;
}

/* line 110, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/tables.sass */
.statbox {
  margin: 0 0 20px 0;
  border: 1px solid #cccccc;
  -webkit-border-radius: 6px;
  -moz-border-radius: 6px;
  -ms-border-radius: 6px;
  -o-border-radius: 6px;
  border-radius: 6px;
  background: white;
}
/* line 116, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/tables.sass */
.statbox h3 {
  font-size: 12px;
  color: #666666;
  text-shadow: 0 1px 0 white;
  margin: 0;
  border-bottom: 1px solid #cccccc;
  padding: 5px 10px;
  background-image: -ms-linear-gradient(bottom, #eaebeb 0%, #fafbfb 100%);
  background-image: -webkit-gradient(linear, 0 0, 0 100%, from(#fafbfb), to(#eaebeb));
  background-image: -webkit-linear-gradient(bottom, #eaebeb 0%, #fafbfb 100%);
  background-image: -o-linear-gradient(bottom, #eaebeb 0%, #fafbfb 100%);
  background-image: linear-gradient(bottom, #eaebeb 0%, #fafbfb 100%);
  background-image: -moz-linear-gradient(bottom, #eaebeb 0%, #fafbfb 100%);
  -webkit-border-radius: 6px 6px 0 0;
  -moz-border-radius: 6px 6px 0 0;
  -ms-border-radius: 6px 6px 0 0;
  -o-border-radius: 6px 6px 0 0;
  border-radius: 6px 6px 0 0;
}
/* line 126, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/tables.sass */
.statbox h3 em {
  font-weight: normal;
  font-style: normal;
}
/* line 130, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/tables.sass */
.statbox h3 strong {
  float: right;
  font-weight: normal;
  font-size: 11px;
}
/* line 134, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/tables.sass */
.statbox h3 strong span {
  font-weight: bold;
}
/* line 137, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/tables.sass */
.statbox th {
  font-size: 9px;
  white-space: nowrap;
  padding: 2px 5px 10px 5px;
}
/* line 142, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/tables.sass */
.statbox td {
  padding: 10px 5px 2px 5px;
  font-size: 14px;
  color: #666666;
}
/* line 147, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/tables.sass */
.statbox td em {
  font-weight: normal;
  font-size: 11px;
  font-style: normal;
  color: #999999;
}

/* line 153, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/tables.sass */
.progress-meter {
  list-style: none;
  margin: 0;
  padding: 0;
  height: 10px;
  border-bottom: 1px solid #cccccc;
  background-image: -ms-linear-gradient(bottom, #bebebe 0%, #cccccc 100%);
  background-image: -webkit-gradient(linear, 0 0, 0 100%, from(#cccccc), to(#bebebe));
  background-image: -webkit-linear-gradient(bottom, #bebebe 0%, #cccccc 100%);
  background-image: -o-linear-gradient(bottom, #bebebe 0%, #cccccc 100%);
  background-image: linear-gradient(bottom, #bebebe 0%, #cccccc 100%);
  background-image: -moz-linear-gradient(bottom, #bebebe 0%, #cccccc 100%);
}
/* line 159, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/tables.sass */
.progress-meter li {
  height: 10px;
  float: left;
}
/* line 162, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/tables.sass */
.progress-meter .completed {
  background-image: -ms-linear-gradient(bottom, #373737 0%, #666666 100%);
  background-image: -webkit-gradient(linear, 0 0, 0 100%, from(#666666), to(#373737));
  background-image: -webkit-linear-gradient(bottom, #373737 0%, #666666 100%);
  background-image: -o-linear-gradient(bottom, #373737 0%, #666666 100%);
  background-image: linear-gradient(bottom, #373737 0%, #666666 100%);
  background-image: -moz-linear-gradient(bottom, #373737 0%, #666666 100%);
}
/* line 164, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/tables.sass */
.progress-meter .in-progress {
  background-image: -ms-linear-gradient(bottom, #6a6b6b 0%, #999999 100%);
  background-image: -webkit-gradient(linear, 0 0, 0 100%, from(#999999), to(#6a6b6b));
  background-image: -webkit-linear-gradient(bottom, #6a6b6b 0%, #999999 100%);
  background-image: -o-linear-gradient(bottom, #6a6b6b 0%, #999999 100%);
  background-image: linear-gradient(bottom, #6a6b6b 0%, #999999 100%);
  background-image: -moz-linear-gradient(bottom, #6a6b6b 0%, #999999 100%);
}

/* line 168, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/tables.sass */
.statbox table {
  margin: 0;
}

/* line 1, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/tabs.css.sass */
.tabs {
  list-style: none;
  margin: 0;
  padding: 0;
  -webkit-border-radius: 3px;
  -moz-border-radius: 3px;
  -ms-border-radius: 3px;
  -o-border-radius: 3px;
  border-radius: 3px;
  border: 1px solid #cccccc;
  float: left;
  height: 30px;
}
/* line 8, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/tabs.css.sass */
.tabs li {
  background-image: -ms-linear-gradient(bottom, #dddddd 0%, #f9f9f9 100%);
  background-image: -webkit-gradient(linear, 0 0, 0 100%, from(#f9f9f9), to(#dddddd));
  background-image: -webkit-linear-gradient(bottom, #dddddd 0%, #f9f9f9 100%);
  background-image: -o-linear-gradient(bottom, #dddddd 0%, #f9f9f9 100%);
  background-image: linear-gradient(bottom, #dddddd 0%, #f9f9f9 100%);
  background-image: -moz-linear-gradient(bottom, #dddddd 0%, #f9f9f9 100%);
  color: #666666;
  float: left;
  font-size: 11px;
  font-weight: bold;
  line-height: 28px;
  text-align: center;
  text-shadow: 0 1px 0 white;
  width: 77px;
}
/* line 19, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/tabs.css.sass */
.tabs li.active {
  background: #f9f9f9;
}
/* line 22, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/tabs.css.sass */
.tabs li a {
  -webkit-box-shadow: #ececec 0 3px 3px 0 inset;
  -moz-box-shadow: #ececec 0 3px 3px 0 inset;
  box-shadow: #ececec 0 3px 3px 0 inset;
  color: #666666;
  display: block;
}
/* line 27, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/tabs.css.sass */
.tabs li + li {
  border-left: 1px solid #cccccc;
}

/* line 31, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/tabs.css.sass */
.nav-tabs {
  list-style: none;
  margin: 0;
  padding: 0;
  text-align: center;
  border-bottom: 1px solid #cccccc;
  position: relative;
}
/* line 37, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/tabs.css.sass */
.nav-tabs li {
  display: inline;
  position: relative;
  bottom: -1px;
}
/* line 42, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/tabs.css.sass */
.nav-tabs li a {
  display: inline-block;
  background-image: -ms-linear-gradient(bottom, #eaebeb 0%, #fafbfb 100%);
  background-image: -webkit-gradient(linear, 0 0, 0 100%, from(#fafbfb), to(#eaebeb));
  background-image: -webkit-linear-gradient(bottom, #eaebeb 0%, #fafbfb 100%);
  background-image: -o-linear-gradient(bottom, #eaebeb 0%, #fafbfb 100%);
  background-image: linear-gradient(bottom, #eaebeb 0%, #fafbfb 100%);
  background-image: -moz-linear-gradient(bottom, #eaebeb 0%, #fafbfb 100%);
  padding: 6px;
  border: 1px solid #cccccc;
  border-width: 1px 0 0 0;
  color: #666666;
  width: 90px;
  text-shadow: 0 -1px 0 white;
  border: 1px solid #cccccc;
}
/* line 52, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/tabs.css.sass */
.nav-tabs li.active a {
  position: relative;
  border-bottom: none;
  border-left: 1px solid #cccccc;
  border-right: 1px solid #cccccc;
  background-image: none;
  background-color: white;
}

/* line 1, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/lists.css.sass */
.arrow-list {
  list-style: none;
  margin: 0;
  padding: 0;
  padding-left: 25px;
  padding-right: 45px;
  position: relative;
}
/* line 7, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/lists.css.sass */
.arrow-list li {
  line-height: 15px;
}
/* line 10, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/lists.css.sass */
.arrow-list li:before {
  content: "\00BB";
  position: absolute;
  left: 14px;
}

/* line 15, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/lists.css.sass */
.task-list {
  list-style: none;
  margin: 0;
  padding: 0;
  margin-bottom: 20px;
  border: 1px solid #cccccc;
  display: inline-block;
}
/* line 20, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/lists.css.sass */
.task-list li {
  padding: 0 0 0 20px;
  border-bottom: 1px dotted #cccccc;
}
/* line 23, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/lists.css.sass */
.task-list li a {
  display: inline-block;
  padding: 10px 10px 10px 20px;
  -webkit-box-shadow: inset 2px 0 0 #ffaa9f;
  -moz-box-shadow: inset 2px 0 0 #ffaa9f;
  box-shadow: inset 2px 0 0 #ffaa9f;
  font-family: Courier, monospace;
}
/* line 28, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/lists.css.sass */
.task-list li:last-child {
  border-bottom: none;
}

/* line 1, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/buttons.css.sass */
button, .btn, .btn-primary, .btn-info, .btn-success, .btn-warning, .btn-caution, .btn-danger, .btn-inverse {
  display: inline-block;
  padding: 4px 10px;
  margin-bottom: 0;
  font-size: 12px;
  line-height: 18px;
  color: #666666;
  text-align: center;
  text-shadow: 0 1px 1px rgba(255, 255, 255, 0.75);
  vertical-align: middle;
  cursor: pointer;
  background-color: #f5f5f5;
  background-image: -ms-linear-gradient(bottom, #dddddd 0%, #f9f9f9 100%);
  background-image: -webkit-gradient(linear, 0 0, 0 100%, from(#f9f9f9), to(#dddddd));
  background-image: -webkit-linear-gradient(bottom, #dddddd 0%, #f9f9f9 100%);
  background-image: -o-linear-gradient(bottom, #dddddd 0%, #f9f9f9 100%);
  background-image: linear-gradient(bottom, #dddddd 0%, #f9f9f9 100%);
  background-image: -moz-linear-gradient(bottom, #dddddd 0%, #f9f9f9 100%);
  background-repeat: repeat-x;
  border: 1px solid #cccccc;
  border-color: rgba(0, 0, 0, 0.1) rgba(0, 0, 0, 0.1) rgba(0, 0, 0, 0.25);
  border-color: #e6e6e6 #e6e6e6 #bfbfbf;
  border-bottom-color: #b3b3b3;
  -webkit-border-radius: 4px;
  -moz-border-radius: 4px;
  -ms-border-radius: 4px;
  -o-border-radius: 4px;
  border-radius: 4px;
  -webkit-box-shadow: inset 0 1px 0 rgba(255, 255, 255, 0.2), 0 1px 2px rgba(0, 0, 0, 0.05);
  -moz-box-shadow: inset 0 1px 0 rgba(255, 255, 255, 0.2), 0 1px 2px rgba(0, 0, 0, 0.05);
  box-shadow: inset 0 1px 0 rgba(255, 255, 255, 0.2), 0 1px 2px rgba(0, 0, 0, 0.05);
}
/* line 22, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/buttons.css.sass */
button:hover, .btn:hover, .btn-primary:hover, .btn-info:hover, .btn-success:hover, .btn-warning:hover, .btn-caution:hover, .btn-danger:hover, .btn-inverse:hover {
  background-color: #dddddd;
  background-position: 0 -15px;
  -webkit-transition: background-position 0.1s linear;
  -moz-transition: background-position 0.1s linear;
  -ms-transition: background-position 0.1s linear;
  -o-transition: background-position 0.1s linear;
  transition: background-position 0.1s linear;
  text-decoration: none;
}
/* line 28, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/buttons.css.sass */
button:active, .btn:active, .btn-primary:active, .btn-info:active, .btn-success:active, .btn-warning:active, .btn-caution:active, .btn-danger:active, .btn-inverse:active {
  background-color: #dddddd;
  outline: 0;
  -webkit-box-shadow: inset 0 2px 4px rgba(0, 0, 0, 0.15), 0 1px 2px rgba(0, 0, 0, 0.05);
  -moz-box-shadow: inset 0 2px 4px rgba(0, 0, 0, 0.15), 0 1px 2px rgba(0, 0, 0, 0.05);
  box-shadow: inset 0 2px 4px rgba(0, 0, 0, 0.15), 0 1px 2px rgba(0, 0, 0, 0.05);
  background-image: none;
}

/* line 34, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/buttons.css.sass */
button + button, .btn + .btn, .btn-primary + .btn, .btn-info + .btn, .btn-success + .btn, .btn-warning + .btn, .btn-caution + .btn, .btn-danger + .btn, .btn-inverse + .btn, .btn + .btn-primary, .btn-primary + .btn-primary, .btn-info + .btn-primary, .btn-success + .btn-primary, .btn-warning + .btn-primary, .btn-caution + .btn-primary, .btn-danger + .btn-primary, .btn-inverse + .btn-primary, .btn + .btn-info, .btn-primary + .btn-info, .btn-info + .btn-info, .btn-success + .btn-info, .btn-warning + .btn-info, .btn-caution + .btn-info, .btn-danger + .btn-info, .btn-inverse + .btn-info, .btn + .btn-success, .btn-primary + .btn-success, .btn-info + .btn-success, .btn-success + .btn-success, .btn-warning + .btn-success, .btn-caution + .btn-success, .btn-danger + .btn-success, .btn-inverse + .btn-success, .btn + .btn-warning, .btn-primary + .btn-warning, .btn-info + .btn-warning, .btn-success + .btn-warning, .btn-warning + .btn-warning, .btn-caution + .btn-warning, .btn-danger + .btn-warning, .btn-inverse + .btn-warning, .btn + .btn-caution, .btn-primary + .btn-caution, .btn-info + .btn-caution, .btn-success + .btn-caution, .btn-warning + .btn-caution, .btn-caution + .btn-caution, .btn-danger + .btn-caution, .btn-inverse + .btn-caution, .btn + .btn-danger, .btn-primary + .btn-danger, .btn-info + .btn-danger, .btn-success + .btn-danger, .btn-warning + .btn-danger, .btn-caution + .btn-danger, .btn-danger + .btn-danger, .btn-inverse + .btn-danger, .btn + .btn-inverse, .btn-primary + .btn-inverse, .btn-info + .btn-inverse, .btn-success + .btn-inverse, .btn-warning + .btn-inverse, .btn-caution + .btn-inverse, .btn-danger + .btn-inverse, .btn-inverse + .btn-inverse {
  margin-left: 5px;
}

/* line 37, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/buttons.css.sass */
.btn-primary {
  background-color: #6dd7e8;
  background-image: -ms-linear-gradient(bottom, #46a4b6 0%, #6dd7e8 100%);
  background-image: -webkit-gradient(linear, 0 0, 0 100%, from(#6dd7e8), to(#46a4b6));
  background-image: -webkit-linear-gradient(bottom, #46a4b6 0%, #6dd7e8 100%);
  background-image: -o-linear-gradient(bottom, #46a4b6 0%, #6dd7e8 100%);
  background-image: linear-gradient(bottom, #46a4b6 0%, #6dd7e8 100%);
  background-image: -moz-linear-gradient(bottom, #46a4b6 0%, #6dd7e8 100%);
  border-color: #46a4b6 #46a4b6 #22829a;
  color: white;
  text-shadow: 0 1px 0 rgba(0, 0, 0, 0.3);
}
/* line 45, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/buttons.css.sass */
.btn-primary:hover, .btn-primary:active {
  background-color: #46a4b6;
}

/* line 48, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/buttons.css.sass */
.btn-info {
  background-color: #0097ca;
  background-image: -ms-linear-gradient(bottom, #0088b4 0%, #0097ca 100%);
  background-image: -webkit-gradient(linear, 0 0, 0 100%, from(#0097ca), to(#0088b4));
  background-image: -webkit-linear-gradient(bottom, #0088b4 0%, #0097ca 100%);
  background-image: -o-linear-gradient(bottom, #0088b4 0%, #0097ca 100%);
  background-image: linear-gradient(bottom, #0088b4 0%, #0097ca 100%);
  background-image: -moz-linear-gradient(bottom, #0088b4 0%, #0097ca 100%);
  border-color: #0088b4 #0088b4 #003580;
  color: white;
  text-shadow: 0 1px 0 rgba(0, 0, 0, 0.3);
}
/* line 56, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/buttons.css.sass */
.btn-info:hover, .btn-info:active {
  background-color: #0088b4;
}

/* line 59, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/buttons.css.sass */
.btn-success {
  background-color: #86b352;
  background-image: -ms-linear-gradient(bottom, #5d7d2e 0%, #86b352 100%);
  background-image: -webkit-gradient(linear, 0 0, 0 100%, from(#86b352), to(#5d7d2e));
  background-image: -webkit-linear-gradient(bottom, #5d7d2e 0%, #86b352 100%);
  background-image: -o-linear-gradient(bottom, #5d7d2e 0%, #86b352 100%);
  background-image: linear-gradient(bottom, #5d7d2e 0%, #86b352 100%);
  background-image: -moz-linear-gradient(bottom, #5d7d2e 0%, #86b352 100%);
  border-color: #5d7d2e #5d7d2e #387038;
  color: white;
  text-shadow: 0 1px 0 rgba(0, 0, 0, 0.3);
}
/* line 67, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/buttons.css.sass */
.btn-success:hover, .btn-success:active {
  background-color: #5d7d2e;
}

/* line 71, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/buttons.css.sass */
.btn-warning {
  background-color: #fbb450;
  background-image: -ms-linear-gradient(bottom, #f89406 0%, #fbb450 100%);
  background-image: -webkit-gradient(linear, 0 0, 0 100%, from(#fbb450), to(#f89406));
  background-image: -webkit-linear-gradient(bottom, #f89406 0%, #fbb450 100%);
  background-image: -o-linear-gradient(bottom, #f89406 0%, #fbb450 100%);
  background-image: linear-gradient(bottom, #f89406 0%, #fbb450 100%);
  background-image: -moz-linear-gradient(bottom, #f89406 0%, #fbb450 100%);
  border-color: #f89406 #f89406 #ad6704;
  color: white;
  text-shadow: 0 1px 0 rgba(0, 0, 0, 0.3);
}
/* line 79, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/buttons.css.sass */
.btn-warning:hover, .btn-warning:active {
  background-color: #f89406;
}

/* line 82, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/buttons.css.sass */
.btn-caution {
  background-color: #f6dc00;
  background-image: -ms-linear-gradient(bottom, #f6b100 0%, #f6dc00 100%);
  background-image: -webkit-gradient(linear, 0 0, 0 100%, from(#f6dc00), to(#f6b100));
  background-image: -webkit-linear-gradient(bottom, #f6b100 0%, #f6dc00 100%);
  background-image: -o-linear-gradient(bottom, #f6b100 0%, #f6dc00 100%);
  background-image: linear-gradient(bottom, #f6b100 0%, #f6dc00 100%);
  background-image: -moz-linear-gradient(bottom, #f6b100 0%, #f6dc00 100%);
  border-color: #f6b100 #f6b100 #c17d00;
  color: white;
  text-shadow: 0 1px 0 rgba(0, 0, 0, 0.3);
}
/* line 90, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/buttons.css.sass */
.btn-caution:hover, .btn-caution:active {
  background-color: #f6b100;
}

/* line 93, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/buttons.css.sass */
.btn-danger {
  background-color: #da4f49;
  background-image: -ms-linear-gradient(bottom, #bd362f 0%, #da4f49 100%);
  background-image: -webkit-gradient(linear, 0 0, 0 100%, from(#da4f49), to(#bd362f));
  background-image: -webkit-linear-gradient(bottom, #bd362f 0%, #da4f49 100%);
  background-image: -o-linear-gradient(bottom, #bd362f 0%, #da4f49 100%);
  background-image: linear-gradient(bottom, #bd362f 0%, #da4f49 100%);
  background-image: -moz-linear-gradient(bottom, #bd362f 0%, #da4f49 100%);
  border-color: #bd362f #bd362f #802420;
  color: white;
  text-shadow: 0 1px 0 rgba(0, 0, 0, 0.3);
}
/* line 101, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/buttons.css.sass */
.btn-danger:hover, .btn-danger:active {
  background-color: #bd362f;
}

/* line 104, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/buttons.css.sass */
.btn-inverse {
  background-color: #555555;
  background-image: -ms-linear-gradient(bottom, #222222 0%, #555555 100%);
  background-image: -webkit-gradient(linear, 0 0, 0 100%, from(#555555), to(#222222));
  background-image: -webkit-linear-gradient(bottom, #222222 0%, #555555 100%);
  background-image: -o-linear-gradient(bottom, #222222 0%, #555555 100%);
  background-image: linear-gradient(bottom, #222222 0%, #555555 100%);
  background-image: -moz-linear-gradient(bottom, #222222 0%, #555555 100%);
  border-color: #222222 #222222 black;
  color: white;
  text-shadow: 0 1px 0 rgba(0, 0, 0, 0.3);
}
/* line 112, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/buttons.css.sass */
.btn-inverse:hover, .btn-inverse:active {
  background-color: #222222;
}

/* line 115, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/buttons.css.sass */
.btn-large {
  font-size: 14px;
  padding: 8px 15px;
}

/* line 119, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/buttons.css.sass */
.btn-small {
  font-size: 10px;
  padding: 2px 8px;
}

/* line 1, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/tooltips.css.sass */
.tooltip {
  background: #333333;
  color: #cccccc;
  padding: 15px;
  -webkit-border-radius: 6px;
  -moz-border-radius: 6px;
  -ms-border-radius: 6px;
  -o-border-radius: 6px;
  border-radius: 6px;
  -webkit-box-shadow: 1px 1px 3px rgba(0, 0, 0, 0.6);
  -moz-box-shadow: 1px 1px 3px rgba(0, 0, 0, 0.6);
  box-shadow: 1px 1px 3px rgba(0, 0, 0, 0.6);
}

/* line 8, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/tooltips.css.sass */
.tooltip:after {
  border: solid transparent;
  content: " ";
  height: 0;
  width: 0;
  position: absolute;
  pointer-events: none;
  border-width: 6px;
}

/* line 17, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/tooltips.css.sass */
[data-placement="bottom"] + .tooltip:after {
  bottom: 100%;
  border-bottom-color: #333333;
  left: 50%;
  margin-left: -6px;
}

/* line 23, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/tooltips.css.sass */
[data-placement="left"] + .tooltip:after {
  left: 100%;
  border-left-color: #333333;
  top: 50%;
  margin-top: -6px;
}

/* line 29, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/tooltips.css.sass */
[data-placement="top"] + .tooltip:after {
  top: 100%;
  border-top-color: #333333;
  left: 50%;
  margin-left: -6px;
}

/* line 35, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/tooltips.css.sass */
[data-placement="right"] + .tooltip:after {
  right: 100%;
  border-right-color: #333333;
  top: 50%;
  margin-top: -6px;
}

/* line 41, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/tooltips.css.sass */
[data-toggle="tooltip"] {
  position: relative;
}
/* line 44, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/tooltips.css.sass */
[data-toggle="tooltip"]:hover + .tooltip, [data-toggle="tooltip"] + .tooltip:hover {
  opacity: 1;
  overflow: visible;
  visibility: visible;
}

/* line 50, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/tooltips.css.sass */
.tooltip {
  margin: 15px;
  opacity: 0;
  position: absolute;
  visibility: hidden;
  z-index: 10;
}
/* line 58, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/tooltips.css.sass */
.tooltip:before {
  content: " ";
  display: block;
  position: absolute;
}

/* line 64, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/tooltips.css.sass */
[data-placement="top"] + .tooltip:before {
  height: 22px;
  width: 100%;
  bottom: -22px;
  left: 0;
}

/* line 71, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/tooltips.css.sass */
[data-placement="right"] + .tooltip:before {
  height: 100%;
  left: -22px;
  top: 0;
  width: 22px;
}

/* line 78, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/tooltips.css.sass */
[data-placement="left"] + .tooltip:before {
  height: 100%;
  right: -22px;
  top: 0;
  width: 22px;
}

/* line 85, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/tooltips.css.sass */
[data-placement="bottom"] + .tooltip:before {
  height: 22px;
  width: 100%;
  top: -22px;
  left: 0;
}

/* line 1, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/icons.css.sass */
.category-icon {
  width: 24px;
  height: 24px;
  -webkit-border-radius: 3px;
  -moz-border-radius: 3px;
  -ms-border-radius: 3px;
  -o-border-radius: 3px;
  border-radius: 3px;
  display: block;
  margin-bottom: 5px;
}

/* line 8, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/icons.css.sass */
.icon-restaurants {
  background: url(/assets/restuarants_s1.png) no-repeat left top;
  background: url(/assets/restuarants_s1.png) no-repeat left top;
  background: url(/assets/restuarants_s1.png) no-repeat left top, -ms-linear-gradient(bottom, #8d2421 0%, #c03a3a 100%);
  background: url(/assets/restuarants_s1.png) no-repeat left top, -webkit-gradient(linear, 0 0, 0 100%, from(#c03a3a), to(#8d2421));
  background: url(/assets/restuarants_s1.png) no-repeat left top, -webkit-linear-gradient(bottom, #8d2421 0%, #c03a3a 100%);
  background: url(/assets/restuarants_s1.png) no-repeat left top, -o-linear-gradient(bottom, #8d2421 0%, #c03a3a 100%);
  background: url(/assets/restuarants_s1.png) no-repeat left top, linear-gradient(bottom, #8d2421 0%, #c03a3a 100%);
  background: url(/assets/restuarants_s1.png) no-repeat left top, -moz-linear-gradient(bottom, #8d2421 0%, #c03a3a 100%);
}

/* line 11, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/icons.css.sass */
.icon-wellness {
  background: url(/assets/wellness_s1.png) no-repeat left top;
  background: url(/assets/wellness_s1.png) no-repeat left top;
  background: url(/assets/wellness_s1.png) no-repeat left top, -ms-linear-gradient(bottom, #ba5201 0%, #eb7607 100%);
  background: url(/assets/wellness_s1.png) no-repeat left top, -webkit-gradient(linear, 0 0, 0 100%, from(#eb7607), to(#ba5201));
  background: url(/assets/wellness_s1.png) no-repeat left top, -webkit-linear-gradient(bottom, #ba5201 0%, #eb7607 100%);
  background: url(/assets/wellness_s1.png) no-repeat left top, -o-linear-gradient(bottom, #ba5201 0%, #eb7607 100%);
  background: url(/assets/wellness_s1.png) no-repeat left top, linear-gradient(bottom, #ba5201 0%, #eb7607 100%);
  background: url(/assets/wellness_s1.png) no-repeat left top, -moz-linear-gradient(bottom, #ba5201 0%, #eb7607 100%);
}

/* line 14, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/icons.css.sass */
.icon-leisure {
  background: url(/assets/leisure_s1.png) no-repeat 50% 50%;
  background: url(/assets/leisure_s1.png) no-repeat 50% 50%;
  background: url(/assets/leisure_s1.png) no-repeat 50% 50%, -ms-linear-gradient(bottom, #c17d00 0%, #f6b100 100%);
  background: url(/assets/leisure_s1.png) no-repeat 50% 50%, -webkit-gradient(linear, 0 0, 0 100%, from(#f6b100), to(#c17d00));
  background: url(/assets/leisure_s1.png) no-repeat 50% 50%, -webkit-linear-gradient(bottom, #c17d00 0%, #f6b100 100%);
  background: url(/assets/leisure_s1.png) no-repeat 50% 50%, -o-linear-gradient(bottom, #c17d00 0%, #f6b100 100%);
  background: url(/assets/leisure_s1.png) no-repeat 50% 50%, linear-gradient(bottom, #c17d00 0%, #f6b100 100%);
  background: url(/assets/leisure_s1.png) no-repeat 50% 50%, -moz-linear-gradient(bottom, #c17d00 0%, #f6b100 100%);
}

/* line 17, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/icons.css.sass */
.icon-services {
  background: url(/assets/services_s1.png) no-repeat 50% 50%;
  background: url(/assets/services_s1.png) no-repeat 50% 50%;
  background: url(/assets/services_s1.png) no-repeat 50% 50%, -ms-linear-gradient(bottom, #5d7d2e 0%, #86b352 100%);
  background: url(/assets/services_s1.png) no-repeat 50% 50%, -webkit-gradient(linear, 0 0, 0 100%, from(#86b352), to(#5d7d2e));
  background: url(/assets/services_s1.png) no-repeat 50% 50%, -webkit-linear-gradient(bottom, #5d7d2e 0%, #86b352 100%);
  background: url(/assets/services_s1.png) no-repeat 50% 50%, -o-linear-gradient(bottom, #5d7d2e 0%, #86b352 100%);
  background: url(/assets/services_s1.png) no-repeat 50% 50%, linear-gradient(bottom, #5d7d2e 0%, #86b352 100%);
  background: url(/assets/services_s1.png) no-repeat 50% 50%, -moz-linear-gradient(bottom, #5d7d2e 0%, #86b352 100%);
}

/* line 20, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/icons.css.sass */
.icon-grouponlive {
  background: url(/assets/grouponlive_s1.png) no-repeat 50% 50%;
  background: url(/assets/grouponlive_s1.png) no-repeat 50% 50%;
  background: url(/assets/grouponlive_s1.png) no-repeat 50% 50%, -ms-linear-gradient(bottom, #46a4b6 0%, #6dd7e8 100%);
  background: url(/assets/grouponlive_s1.png) no-repeat 50% 50%, -webkit-gradient(linear, 0 0, 0 100%, from(#6dd7e8), to(#46a4b6));
  background: url(/assets/grouponlive_s1.png) no-repeat 50% 50%, -webkit-linear-gradient(bottom, #46a4b6 0%, #6dd7e8 100%);
  background: url(/assets/grouponlive_s1.png) no-repeat 50% 50%, -o-linear-gradient(bottom, #46a4b6 0%, #6dd7e8 100%);
  background: url(/assets/grouponlive_s1.png) no-repeat 50% 50%, linear-gradient(bottom, #46a4b6 0%, #6dd7e8 100%);
  background: url(/assets/grouponlive_s1.png) no-repeat 50% 50%, -moz-linear-gradient(bottom, #46a4b6 0%, #6dd7e8 100%);
}

/* line 23, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/icons.css.sass */
.icon-shopping {
  background: url(/assets/shopping_s1.png) no-repeat 50% 50%;
  background: url(/assets/shopping_s1.png) no-repeat 50% 50%;
  background: url(/assets/shopping_s1.png) no-repeat 50% 50%, -ms-linear-gradient(bottom, #0088b4 0%, #0097ca 100%);
  background: url(/assets/shopping_s1.png) no-repeat 50% 50%, -webkit-gradient(linear, 0 0, 0 100%, from(#0097ca), to(#0088b4));
  background: url(/assets/shopping_s1.png) no-repeat 50% 50%, -webkit-linear-gradient(bottom, #0088b4 0%, #0097ca 100%);
  background: url(/assets/shopping_s1.png) no-repeat 50% 50%, -o-linear-gradient(bottom, #0088b4 0%, #0097ca 100%);
  background: url(/assets/shopping_s1.png) no-repeat 50% 50%, linear-gradient(bottom, #0088b4 0%, #0097ca 100%);
  background: url(/assets/shopping_s1.png) no-repeat 50% 50%, -moz-linear-gradient(bottom, #0088b4 0%, #0097ca 100%);
}

/* line 26, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/icons.css.sass */
.icon-beauty {
  background: url(/assets/beauty_s1.png) no-repeat 50% 50%;
  background: url(/assets/beauty_s1.png) no-repeat 50% 50%;
  background: url(/assets/beauty_s1.png) no-repeat 50% 50%, -ms-linear-gradient(bottom, #3c346f 0%, #635ea6 100%);
  background: url(/assets/beauty_s1.png) no-repeat 50% 50%, -webkit-gradient(linear, 0 0, 0 100%, from(#635ea6), to(#3c346f));
  background: url(/assets/beauty_s1.png) no-repeat 50% 50%, -webkit-linear-gradient(bottom, #3c346f 0%, #635ea6 100%);
  background: url(/assets/beauty_s1.png) no-repeat 50% 50%, -o-linear-gradient(bottom, #3c346f 0%, #635ea6 100%);
  background: url(/assets/beauty_s1.png) no-repeat 50% 50%, linear-gradient(bottom, #3c346f 0%, #635ea6 100%);
  background: url(/assets/beauty_s1.png) no-repeat 50% 50%, -moz-linear-gradient(bottom, #3c346f 0%, #635ea6 100%);
}

/* line 29, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/icons.css.sass */
.icon-healthcare {
  background: url(/assets/healthcare_s1.png) no-repeat 50% 50%;
  background: url(/assets/healthcare_s1.png) no-repeat 50% 50%;
  background: url(/assets/healthcare_s1.png) no-repeat 50% 50%, -ms-linear-gradient(bottom, #891a6a 0%, #c32999 100%);
  background: url(/assets/healthcare_s1.png) no-repeat 50% 50%, -webkit-gradient(linear, 0 0, 0 100%, from(#c32999), to(#891a6a));
  background: url(/assets/healthcare_s1.png) no-repeat 50% 50%, -webkit-linear-gradient(bottom, #891a6a 0%, #c32999 100%);
  background: url(/assets/healthcare_s1.png) no-repeat 50% 50%, -o-linear-gradient(bottom, #891a6a 0%, #c32999 100%);
  background: url(/assets/healthcare_s1.png) no-repeat 50% 50%, linear-gradient(bottom, #891a6a 0%, #c32999 100%);
  background: url(/assets/healthcare_s1.png) no-repeat 50% 50%, -moz-linear-gradient(bottom, #891a6a 0%, #c32999 100%);
}

/* line 32, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/icons.css.sass */
.icon-getaways {
  background: url(/assets/getaways_s1.png) no-repeat 50% 50%;
  background: url(/assets/getaways_s1.png) no-repeat 50% 50%;
  background: url(/assets/getaways_s1.png) no-repeat 50% 50%, -ms-linear-gradient(bottom, #616161 0%, #989898 100%);
  background: url(/assets/getaways_s1.png) no-repeat 50% 50%, -webkit-gradient(linear, 0 0, 0 100%, from(#989898), to(#616161));
  background: url(/assets/getaways_s1.png) no-repeat 50% 50%, -webkit-linear-gradient(bottom, #616161 0%, #989898 100%);
  background: url(/assets/getaways_s1.png) no-repeat 50% 50%, -o-linear-gradient(bottom, #616161 0%, #989898 100%);
  background: url(/assets/getaways_s1.png) no-repeat 50% 50%, linear-gradient(bottom, #616161 0%, #989898 100%);
  background: url(/assets/getaways_s1.png) no-repeat 50% 50%, -moz-linear-gradient(bottom, #616161 0%, #989898 100%);
}

/* line 35, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/icons.css.sass */
.icon-grassroots {
  background: url(/assets/grassroots_s1.png) no-repeat 50% 50%;
  background: url(/assets/grassroots_s1.png) no-repeat 50% 50%;
  background: url(/assets/grassroots_s1.png) no-repeat 50% 50%, -ms-linear-gradient(bottom, #616161 0%, #989898 100%);
  background: url(/assets/grassroots_s1.png) no-repeat 50% 50%, -webkit-gradient(linear, 0 0, 0 100%, from(#989898), to(#616161));
  background: url(/assets/grassroots_s1.png) no-repeat 50% 50%, -webkit-linear-gradient(bottom, #616161 0%, #989898 100%);
  background: url(/assets/grassroots_s1.png) no-repeat 50% 50%, -o-linear-gradient(bottom, #616161 0%, #989898 100%);
  background: url(/assets/grassroots_s1.png) no-repeat 50% 50%, linear-gradient(bottom, #616161 0%, #989898 100%);
  background: url(/assets/grassroots_s1.png) no-repeat 50% 50%, -moz-linear-gradient(bottom, #616161 0%, #989898 100%);
}

/* line 38, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/icons.css.sass */
.icon-rewards {
  background: url(/assets/rewards_s1.png) no-repeat 50% 50%;
  background: url(/assets/rewards_s1.png) no-repeat 50% 50%;
  background: url(/assets/rewards_s1.png) no-repeat 50% 50%, -ms-linear-gradient(bottom, #616161 0%, #989898 100%);
  background: url(/assets/rewards_s1.png) no-repeat 50% 50%, -webkit-gradient(linear, 0 0, 0 100%, from(#989898), to(#616161));
  background: url(/assets/rewards_s1.png) no-repeat 50% 50%, -webkit-linear-gradient(bottom, #616161 0%, #989898 100%);
  background: url(/assets/rewards_s1.png) no-repeat 50% 50%, -o-linear-gradient(bottom, #616161 0%, #989898 100%);
  background: url(/assets/rewards_s1.png) no-repeat 50% 50%, linear-gradient(bottom, #616161 0%, #989898 100%);
  background: url(/assets/rewards_s1.png) no-repeat 50% 50%, -moz-linear-gradient(bottom, #616161 0%, #989898 100%);
}

/* line 41, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/icons.css.sass */
.icon-goods {
  background: url(/assets/goods_s1.png) no-repeat 50% 50%;
  background: url(/assets/goods_s1.png) no-repeat 50% 50%;
  background: url(/assets/goods_s1.png) no-repeat 50% 50%, -ms-linear-gradient(bottom, #616161 0%, #989898 100%);
  background: url(/assets/goods_s1.png) no-repeat 50% 50%, -webkit-gradient(linear, 0 0, 0 100%, from(#989898), to(#616161));
  background: url(/assets/goods_s1.png) no-repeat 50% 50%, -webkit-linear-gradient(bottom, #616161 0%, #989898 100%);
  background: url(/assets/goods_s1.png) no-repeat 50% 50%, -o-linear-gradient(bottom, #616161 0%, #989898 100%);
  background: url(/assets/goods_s1.png) no-repeat 50% 50%, linear-gradient(bottom, #616161 0%, #989898 100%);
  background: url(/assets/goods_s1.png) no-repeat 50% 50%, -moz-linear-gradient(bottom, #616161 0%, #989898 100%);
}

/* line 1, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/labels.css.sass */
.label, .label-danger,
.label-warning,
.label-caution,
.label-success,
.label-inverse {
  -webkit-border-radius: 11px;
  -moz-border-radius: 11px;
  -ms-border-radius: 11px;
  -o-border-radius: 11px;
  border-radius: 11px;
  background: #ededed;
  color: #666666;
  height: 22px;
  line-height: 22px;
  text-align: center;
  min-width: 100px;
  display: inline-block;
  text-shadow: 0 -1px 0 white;
}

/* line 12, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/labels.css.sass */
.label-danger {
  background: #cc2127;
}

/* line 14, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/labels.css.sass */
.label-warning {
  background: #f57e2c;
}

/* line 16, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/labels.css.sass */
.label-caution {
  background: #daa501;
}

/* line 18, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/labels.css.sass */
.label-success {
  background: #8eb316;
}

/* line 20, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/labels.css.sass */
.label-inverse {
  background: #666666;
}

/* line 23, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/labels.css.sass */
.label-danger,
.label-warning,
.label-caution,
.label-success,
.label-inverse {
  color: white;
  text-shadow: 0 -1px 0 rgba(0, 0, 0, 0.3);
}

/* line 33, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/labels.css.sass */
.badge-counter {
  color: white;
  background: #aaaaaa;
  text-shadow: 0 1px 0 rgba(0, 0, 0, 0.3);
  -webkit-border-radius: 10px;
  -moz-border-radius: 10px;
  -ms-border-radius: 10px;
  -o-border-radius: 10px;
  border-radius: 10px;
  padding: 4px 8px;
  font-size: 11px;
  line-height: 13px;
  min-width: 24px;
  text-align: center;
}

/* line 44, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/labels.css.sass */
.badge-single {
  text-shadow: 0 1px 0 rgba(0, 0, 0, 0.3);
  background: #cccccc;
  -webkit-border-radius: 10px;
  -moz-border-radius: 10px;
  -ms-border-radius: 10px;
  -o-border-radius: 10px;
  border-radius: 10px;
  min-width: 20px;
  line-height: 20px;
  display: block;
  text-align: center;
  font-size: 10px;
  color: white;
  float: left;
  margin: 2px;
}

/* line 57, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/labels.css.sass */
.badge-success {
  background: #91b51b;
}

/* line 59, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/labels.css.sass */
.badge-warning {
  background: #ff9929;
}

/* line 61, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/labels.css.sass */
.badge-danger {
  background: #cc0003;
}

/* line 63, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/labels.css.sass */
.badge-inverse {
  background: #666666;
}

/* line 15, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/layout.css.sass */
body {
  background: url(/assets/bg-body.png) left top;
  margin: 0;
}

/* line 19, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/layout.css.sass */
header {
  background-image: -ms-linear-gradient(bottom, #4994aa 0%, #509fb7 100%);
  background-image: -webkit-gradient(linear, 0 0, 0 100%, from(#509fb7), to(#4994aa));
  background-image: -webkit-linear-gradient(bottom, #4994aa 0%, #509fb7 100%);
  background-image: -o-linear-gradient(bottom, #4994aa 0%, #509fb7 100%);
  background-image: linear-gradient(bottom, #4994aa 0%, #509fb7 100%);
  background-image: -moz-linear-gradient(bottom, #4994aa 0%, #509fb7 100%);
  border-bottom: 1px solid #33798f;
  height: 50px;
}
/* line 24, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/layout.css.sass */
header .container {
  padding: 0 30px;
}

/* line 27, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/layout.css.sass */
.control-bar {
  background-color: #f5f5f5;
  border-bottom: 1px solid #cccccc;
}

/* line 31, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/layout.css.sass */
.content > .container {
  -webkit-box-shadow: rgba(0, 0, 0, 0.3) 0 0 6px 0;
  -moz-box-shadow: rgba(0, 0, 0, 0.3) 0 0 6px 0;
  box-shadow: rgba(0, 0, 0, 0.3) 0 0 6px 0;
  background-color: white;
  border: 1px solid #cccccc;
  margin: 0 30px;
}

/* line 37, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/layout.css.sass */
.main .container {
  min-height: 660px;
  padding: 20px;
}

/* line 41, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/layout.css.sass */
.control-bar .container {
  padding: 20px;
}

/* Body Classes */
/* with-sidebar */
/* line 50, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/layout.css.sass */
.with-sidebar .content > .container {
  position: relative;
}
/* line 53, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/layout.css.sass */
.with-sidebar .main {
  padding-right: 280px;
  -webkit-box-shadow: inset -280px 0 0 #fafafa;
  -moz-box-shadow: inset -280px 0 0 #fafafa;
  box-shadow: inset -280px 0 0 #fafafa;
}
/* line 56, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/layout.css.sass */
.with-sidebar .main > .container {
  border-right: 1px solid #cccccc;
}
/* line 59, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/layout.css.sass */
.with-sidebar .sidebar {
  position: absolute;
  width: 240px;
  top: 20px;
  right: 20px;
}

/* fixed */
/* line 68, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/layout.css.sass */
.fixed header .container,
.fixed .content {
  margin: 0 auto;
  max-width: 1280px;
}
/* line 73, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/layout.css.sass */
.fixed header .container {
  max-width: 1280px;
}

/* nav */
/* line 79, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/layout.css.sass */
.nav .content > .container {
  -webkit-box-shadow: inset 200px 0 0 #f9f9f9;
  -moz-box-shadow: inset 200px 0 0 #f9f9f9;
  box-shadow: inset 200px 0 0 #f9f9f9;
}
/* line 82, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/layout.css.sass */
.nav .content > .container aside {
  float: left;
  width: 200px;
}
/* line 86, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/layout.css.sass */
.nav .content > .container .main {
  border-left: 1px solid #cccccc;
  margin-left: 200px;
}

/* panel-in */
/* line 93, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/layout.css.sass */
.panel-in .control-bar {
  height: 70px;
}
/* line 96, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/layout.css.sass */
.panel-in .content > .container,
.panel-in .main .container {
  border-top: 0;
  min-height: 660px;
}

/* panel-out */
/* line 104, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/layout.css.sass */
.panel-out .control-bar {
  background-color: #eff5e7;
  border-bottom: 2px solid #dfe7ce;
  height: 120px;
}
/* line 108, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/layout.css.sass */
.panel-out .control-bar .container {
  padding: 20px 30px;
}
/* line 111, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/layout.css.sass */
.panel-out .content > .container,
.panel-out .main .container {
  min-height: 660px;
}
/* line 115, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/layout.css.sass */
.panel-out .content > .container {
  -webkit-border-radius: 6px;
  -moz-border-radius: 6px;
  -ms-border-radius: 6px;
  -o-border-radius: 6px;
  border-radius: 6px;
  margin-top: -20px;
}
/* line 120, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/layout.css.sass */
.panel-out.fixed .control-bar .container {
  margin: 0 auto;
  max-width: 1280px;
}

/* line 1, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/header.css.sass */
.logo {
  float: left;
  margin: 13px 20px 13px 7px;
}

/* line 6, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/header.css.sass */
header nav ul {
  list-style: none;
  margin: 0;
  padding: 0;
  -webkit-box-shadow: 1px 0 0 #79a8b7;
  -moz-box-shadow: 1px 0 0 #79a8b7;
  box-shadow: 1px 0 0 #79a8b7;
  border-right: 1px solid #33798f;
  float: left;
}
/* line 12, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/header.css.sass */
header nav ul li {
  float: left;
}
/* line 15, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/header.css.sass */
header nav ul li a {
  -webkit-box-shadow: 1px 0 0 #79a8b7 inset;
  -moz-box-shadow: 1px 0 0 #79a8b7 inset;
  box-shadow: 1px 0 0 #79a8b7 inset;
  border-left: 1px solid #33798f;
  color: #e4f0f3;
  display: block;
  font-size: 13px;
  height: 48px;
  line-height: 48px;
  text-align: center;
  text-decoration: none;
  text-shadow: -1px 0 1px rgba(0, 0, 0, 0.3);
  min-width: 90px;
  padding: 0 20px;
}
/* line 29, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/header.css.sass */
header nav ul li.active a, header nav ul li:hover a {
  -webkit-box-shadow: 0 0 0 white inset;
  -moz-box-shadow: 0 0 0 white inset;
  box-shadow: 0 0 0 white inset;
  background-image: -ms-linear-gradient(bottom, #337a90 0%, #4691a7 100%);
  background-image: -webkit-gradient(linear, 0 0, 0 100%, from(#4691a7), to(#337a90));
  background-image: -webkit-linear-gradient(bottom, #337a90 0%, #4691a7 100%);
  background-image: -o-linear-gradient(bottom, #337a90 0%, #4691a7 100%);
  background-image: linear-gradient(bottom, #337a90 0%, #4691a7 100%);
  background-image: -moz-linear-gradient(bottom, #337a90 0%, #4691a7 100%);
  border-left: 1px solid #33798f;
}
/* line 34, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/header.css.sass */
header form {
  text-align: right;
  padding-right: 20px;
  padding-top: 10px;
}

/* line 1, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/sidenav.css.sass */
.metrics {
  list-style: none;
  margin: 0;
  padding: 0;
  clear: left;
  border-bottom: 1px solid #cccccc;
}
/* line 6, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/sidenav.css.sass */
.metrics li > span {
  background-image: -ms-linear-gradient(bottom, #dddddd 0%, #f9f9f9 100%);
  background-image: -webkit-gradient(linear, 0 0, 0 100%, from(#f9f9f9), to(#dddddd));
  background-image: -webkit-linear-gradient(bottom, #dddddd 0%, #f9f9f9 100%);
  background-image: -o-linear-gradient(bottom, #dddddd 0%, #f9f9f9 100%);
  background-image: linear-gradient(bottom, #dddddd 0%, #f9f9f9 100%);
  background-image: -moz-linear-gradient(bottom, #dddddd 0%, #f9f9f9 100%);
  border-top: 1px solid #cccccc;
  display: block;
  font-weight: bold;
  line-height: 29px;
  padding: 0 20px;
  color: #666666;
}
/* line 15, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/sidenav.css.sass */
.metrics dl {
  margin: 0;
  border-top: 1px solid #cccccc;
}
/* line 19, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/sidenav.css.sass */
.metrics dt, .metrics dd {
  font-size: 11px;
  font-weight: 500;
  line-height: 30px;
  padding: 0 20px;
}
/* line 25, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/sidenav.css.sass */
.metrics dt + dd + dt,
.metrics dd + dt + dd {
  border-top: 1px solid #e9e9e9;
}
/* line 29, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/sidenav.css.sass */
.metrics dt {
  clear: left;
  color: #999999;
  float: left;
}
/* line 34, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/sidenav.css.sass */
.metrics dd {
  text-align: right;
}
/* line 37, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/sidenav.css.sass */
.metrics > li:focus,
.metrics > li > span:focus {
  outline: none;
}

/* line 42, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/sidenav.css.sass */
.accordion li.open span {
  background: url(/assets/arrow-down-sm.png) no-repeat 174px 12px;
  background: url(/assets/arrow-down-sm.png) no-repeat 174px 12px;
  background: url(/assets/arrow-down-sm.png) no-repeat 174px 12px, -ms-linear-gradient(bottom, #dddddd 0%, #f9f9f9 100%);
  background: url(/assets/arrow-down-sm.png) no-repeat 174px 12px, -webkit-gradient(linear, 0 0, 0 100%, from(#f9f9f9), to(#dddddd));
  background: url(/assets/arrow-down-sm.png) no-repeat 174px 12px, -webkit-linear-gradient(bottom, #dddddd 0%, #f9f9f9 100%);
  background: url(/assets/arrow-down-sm.png) no-repeat 174px 12px, -o-linear-gradient(bottom, #dddddd 0%, #f9f9f9 100%);
  background: url(/assets/arrow-down-sm.png) no-repeat 174px 12px, linear-gradient(bottom, #dddddd 0%, #f9f9f9 100%);
  background: url(/assets/arrow-down-sm.png) no-repeat 174px 12px, -moz-linear-gradient(bottom, #dddddd 0%, #f9f9f9 100%);
}
/* line 45, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/sidenav.css.sass */
.accordion li span {
  background: url(/assets/arrow-right-sm.png) no-repeat 175px 12px;
  background: url(/assets/arrow-right-sm.png) no-repeat 175px 12px;
  background: url(/assets/arrow-right-sm.png) no-repeat 175px 12px, -ms-linear-gradient(bottom, #dddddd 0%, #f9f9f9 100%);
  background: url(/assets/arrow-right-sm.png) no-repeat 175px 12px, -webkit-gradient(linear, 0 0, 0 100%, from(#f9f9f9), to(#dddddd));
  background: url(/assets/arrow-right-sm.png) no-repeat 175px 12px, -webkit-linear-gradient(bottom, #dddddd 0%, #f9f9f9 100%);
  background: url(/assets/arrow-right-sm.png) no-repeat 175px 12px, -o-linear-gradient(bottom, #dddddd 0%, #f9f9f9 100%);
  background: url(/assets/arrow-right-sm.png) no-repeat 175px 12px, linear-gradient(bottom, #dddddd 0%, #f9f9f9 100%);
  background: url(/assets/arrow-right-sm.png) no-repeat 175px 12px, -moz-linear-gradient(bottom, #dddddd 0%, #f9f9f9 100%);
}
/* line 48, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/sidenav.css.sass */
.accordion li dl {
  display: none;
}
/* line 51, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/sidenav.css.sass */
.accordion li.open dl {
  display: block;
}

/* line 55, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/sidenav.css.sass */
aside .tabs {
  border: 1px solid #cccccc;
  -webkit-border-radius: 3px;
  -moz-border-radius: 3px;
  -ms-border-radius: 3px;
  -o-border-radius: 3px;
  border-radius: 3px;
  margin: 15px 20px;
}
/* line 60, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/sidenav.css.sass */
aside .tabs li {
  display: block;
  float: left;
  width: 52px;
}
/* line 65, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/sidenav.css.sass */
aside .tabs li + li {
  border-left: 1px solid #cccccc;
}
/* line 68, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/sidenav.css.sass */
aside .info {
  margin: 0 15px;
}
/* line 71, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/sidenav.css.sass */
aside .info dl {
  margin: 12px 0 24px 0;
}
/* line 74, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/sidenav.css.sass */
aside .info dt {
  font-weight: bold;
}
/* line 77, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/sidenav.css.sass */
aside .info dd {
  margin: 0 0 12px 0;
  padding: 0;
}

/* line 81, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/sidenav.css.sass */
.nav-ribbon, .nav-ribbon-icons {
  -webkit-box-shadow: white 0 1px 0 0;
  -moz-box-shadow: white 0 1px 0 0;
  box-shadow: white 0 1px 0 0;
  list-style: none;
  margin: 0;
  padding: 0;
  border-top: 1px solid #d9d9d9;
}
/* line 86, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/sidenav.css.sass */
.nav-ribbon li, .nav-ribbon-icons li {
  position: relative;
}
/* line 89, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/sidenav.css.sass */
.nav-ribbon li.active, .nav-ribbon-icons li.active {
  background-image: -ms-linear-gradient(bottom, #5bb9d4 0%, #3aa8c7 100%);
  background-image: -webkit-gradient(linear, 0 0, 0 100%, from(#3aa8c7), to(#5bb9d4));
  background-image: -webkit-linear-gradient(bottom, #5bb9d4 0%, #3aa8c7 100%);
  background-image: -o-linear-gradient(bottom, #5bb9d4 0%, #3aa8c7 100%);
  background-image: linear-gradient(bottom, #5bb9d4 0%, #3aa8c7 100%);
  background-image: -moz-linear-gradient(bottom, #5bb9d4 0%, #3aa8c7 100%);
}
/* line 91, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/sidenav.css.sass */
.nav-ribbon li.active a, .nav-ribbon-icons li.active a {
  -webkit-box-shadow: white 0 0 0 0;
  -moz-box-shadow: white 0 0 0 0;
  box-shadow: white 0 0 0 0;
  border-bottom: 1px solid #3aa8c7;
  border-right: 1px solid #3aa8c7;
  border-top: 1px solid #3aa8c7;
  color: white;
  height: 40px;
  margin-top: -1px;
  text-shadow: -1px 0 1px rgba(0, 0, 0, 0.3);
  width: 201px;
}
/* line 102, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/sidenav.css.sass */
.nav-ribbon li.active:before, .nav-ribbon-icons li.active:before {
  background: url(/assets/ribbon.png) no-repeat left top;
  content: "";
  height: 50px;
  left: -17px;
  position: absolute;
  top: 0;
  width: 17px;
}
/* line 111, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/sidenav.css.sass */
.nav-ribbon a, .nav-ribbon-icons a {
  -webkit-box-shadow: white 0 1px 0 0 inset;
  -moz-box-shadow: white 0 1px 0 0 inset;
  box-shadow: white 0 1px 0 0 inset;
  border-bottom: 1px solid #d9d9d9;
  color: #666666;
  display: block;
  height: 40px;
  line-height: 40px;
  padding: 0 20px 0 20px;
  text-decoration: none;
  text-shadow: 0 1px 0 white;
}

/* line 124, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/sidenav.css.sass */
.nav-ribbon-icons a {
  padding: 0 20px 0 46px;
}

/* line 127, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/sidenav.css.sass */
.nav-plain {
  list-style: none;
  margin: 0;
  padding: 0;
}
/* line 130, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/sidenav.css.sass */
.nav-plain a {
  display: block;
  padding: 10px 13px 10px 19px;
  color: gray;
  line-height: 21px;
  font-weight: bold;
  text-shadow: 0 1px 0 white;
  border-bottom: 1px solid #cccccc;
  font-size: 13px;
}
/* line 139, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/sidenav.css.sass */
.nav-plain a:hover {
  color: #666666;
}
/* line 141, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/sidenav.css.sass */
.nav-plain .active a {
  background-color: #f2f2f2;
  -webkit-box-shadow: inset 0 0 5px 1px #ebebeb;
  -moz-box-shadow: inset 0 0 5px 1px #ebebeb;
  box-shadow: inset 0 0 5px 1px #ebebeb;
  color: #666666;
}

/* line 1, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/grid.css.sass */
* {
  -webkit-box-sizing: border-box;
  -moz-box-sizing: border-box;
  box-sizing: border-box;
}

/* line 4, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/grid.css.sass */
.row {
  margin: 0 auto;
  max-width: 100%;
  min-width: 768px;
  width: 1000px;
}

/* line 10, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/grid.css.sass */
.column, .columns {
  float: left;
  min-height: 1px;
  padding: 0 10px;
  position: relative;
}

/* line 16, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/grid.css.sass */
.row .one {
  width: 8.33%;
}

/* line 18, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/grid.css.sass */
.row .two {
  width: 16.66%;
}

/* line 20, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/grid.css.sass */
.row .three {
  width: 25%;
}

/* line 22, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/grid.css.sass */
.row .four {
  width: 33.33%;
}

/* line 24, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/grid.css.sass */
.row .five {
  width: 41.66%;
}

/* line 26, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/grid.css.sass */
.row .six {
  width: 50%;
}

/* line 28, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/grid.css.sass */
.row .seven {
  width: 58.33%;
}

/* line 30, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/grid.css.sass */
.row .eight {
  width: 66.66%;
}

/* line 32, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/grid.css.sass */
.row .nine {
  width: 75%;
}

/* line 34, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/grid.css.sass */
.row .ten {
  width: 83.33%;
}

/* line 36, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/grid.css.sass */
.row .eleven {
  width: 91.66%;
}

/* line 38, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/grid.css.sass */
.row .twelve {
  width: 100%;
}

/* line 41, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/grid.css.sass */
.row .row {
  margin: 0 -10px;
  max-width: none;
  min-width: 0;
  width: auto;
}

/* line 47, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/grid.css.sass */
.row:before,
.row:after,
.clearfix:before,
.clearfix:after {
  content: "";
  display: table;
}

/* line 53, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/grid.css.sass */
.row:after,
.clearfix:after {
  clear: both;
}

/* line 56, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/grid.css.sass */
.row,
.clearfix {
  zoom: 1;
}

/* line 60, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/grid.css.sass */
.first {
  padding-left: 0;
}

/* line 63, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/grid.css.sass */
[class*="column"] + [class*="column"]:last-child {
  float: right;
}

/* line 65, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/grid.css.sass */
[class*="column"] + [class*="column"].end {
  float: left;
}

/* line 68, ../../vendor/gems/toolstrap/app/assets/stylesheets/base/grid.css.sass */
.pull-right {
  float: right;
}

/* line 21, ../../vendor/gems/toolstrap/app/assets/stylesheets/toolstrap.css.sass */
.low, .caution {
  color: red;
  text-shadow: 0 1px 0 white;
}

/* line 25, ../../vendor/gems/toolstrap/app/assets/stylesheets/toolstrap.css.sass */
.moderate {
  color: #ff9900;
  text-shadow: 0 1px 0 white;
}

/* line 29, ../../vendor/gems/toolstrap/app/assets/stylesheets/toolstrap.css.sass */
.optimal {
  color: #91b51b;
  text-shadow: 0 1px 0 white;
}