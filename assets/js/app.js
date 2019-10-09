// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import css from "../css/app.css"

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import dependencies
//
import "phoenix_html"

// Import local files
//
// Local files can be imported directly using relative paths, for example:
import socket from "./socket"
import PhoneValidation from "./phone_validation"
import LoanApplication from "./loan_application"
import Timer from "./timer"

LoanApplication.init(socket, document.getElementById("check-rate"))
PhoneValidation.init(document.getElementById("loan_application_user_phone_number"))
Timer.init(document.getElementById("interest-rate"))
