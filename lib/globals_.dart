import 'dart:async';
import 'dart:convert';

import 'package:bot_md/Auth/login.dart';
import 'package:bot_md/Navigation/laboratories.dart';
import 'package:bot_md/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/state_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'Dashboard/main_nav.dart';

RxMap currentUserData = RxMap({});
RxMap adminDetails = RxMap({});
late DocumentSnapshot currentUser;
FirebaseAuth auth = FirebaseAuth.instance;
FirebaseMessaging messaging = FirebaseMessaging.instance;

List worldCountries_hopkins = [
  {"iso": "CHN", "name": "China"},
  {"iso": "TWN", "name": "Taipei and environs"},
  {"iso": "USA", "name": "US"},
  {"iso": "JPN", "name": "Japan"},
  {"iso": "THA", "name": "Thailand"},
  {"iso": "KOR", "name": "Korea, South"},
  {"iso": "SGP", "name": "Singapore"},
  {"iso": "PHL", "name": "Philippines"},
  {"iso": "MYS", "name": "Malaysia"},
  {"iso": "VNM", "name": "Vietnam"},
  {"iso": "AUS", "name": "Australia"},
  {"iso": "MEX", "name": "Mexico"},
  {"iso": "BRA", "name": "Brazil"},
  {"iso": "COL", "name": "Colombia"},
  {"iso": "FRA", "name": "France"},
  {"iso": "NPL", "name": "Nepal"},
  {"iso": "CAN", "name": "Canada"},
  {"iso": "KHM", "name": "Cambodia"},
  {"iso": "LKA", "name": "Sri Lanka"},
  {"iso": "CIV", "name": "Cote d'Ivoire"},
  {"iso": "DEU", "name": "Germany"},
  {"iso": "FIN", "name": "Finland"},
  {"iso": "ARE", "name": "United Arab Emirates"},
  {"iso": "IND", "name": "India"},
  {"iso": "ITA", "name": "Italy"},
  {"iso": "GBR", "name": "United Kingdom"},
  {"iso": "RUS", "name": "Russia"},
  {"iso": "SWE", "name": "Sweden"},
  {"iso": "ESP", "name": "Spain"},
  {"iso": "BEL", "name": "Belgium"},
  {"iso": "Others", "name": "Others"},
  {"iso": "EGY", "name": "Egypt"},
  {"iso": "IRN", "name": "Iran"},
  {"iso": "ISR", "name": "Israel"},
  {"iso": "LBN", "name": "Lebanon"},
  {"iso": "IRQ", "name": "Iraq"},
  {"iso": "OMN", "name": "Oman"},
  {"iso": "AFG", "name": "Afghanistan"},
  {"iso": "BHR", "name": "Bahrain"},
  {"iso": "KWT", "name": "Kuwait"},
  {"iso": "AUT", "name": "Austria"},
  {"iso": "DZA", "name": "Algeria"},
  {"iso": "HRV", "name": "Croatia"},
  {"iso": "CHE", "name": "Switzerland"},
  {"iso": "PAK", "name": "Pakistan"},
  {"iso": "GEO", "name": "Georgia"},
  {"iso": "GRC", "name": "Greece"},
  {"iso": "MKD", "name": "North Macedonia"},
  {"iso": "NOR", "name": "Norway"},
  {"iso": "ROU", "name": "Romania"},
  {"iso": "DNK", "name": "Denmark"},
  {"iso": "EST", "name": "Estonia"},
  {"iso": "NLD", "name": "Netherlands"},
  {"iso": "SMR", "name": "San Marino"},
  {"iso": "AZE", "name": "Azerbaijan"},
  {"iso": "BLR", "name": "Belarus"},
  {"iso": "ISL", "name": "Iceland"},
  {"iso": "LTU", "name": "Lithuania"},
  {"iso": "NZL", "name": "New Zealand"},
  {"iso": "NGA", "name": "Nigeria"},
  {"iso": "IRL", "name": "Ireland"},
  {"iso": "LUX", "name": "Luxembourg"},
  {"iso": "MCO", "name": "Monaco"},
  {"iso": "QAT", "name": "Qatar"},
  {"iso": "ECU", "name": "Ecuador"},
  {"iso": "CZE", "name": "Czechia"},
  {"iso": "ARM", "name": "Armenia"},
  {"iso": "DOM", "name": "Dominican Republic"},
  {"iso": "IDN", "name": "Indonesia"},
  {"iso": "PRT", "name": "Portugal"},
  {"iso": "AND", "name": "Andorra"},
  {"iso": "LVA", "name": "Latvia"},
  {"iso": "MAR", "name": "Morocco"},
  {"iso": "SAU", "name": "Saudi Arabia"},
  {"iso": "SEN", "name": "Senegal"},
  {"iso": "ARG", "name": "Argentina"},
  {"iso": "CHL", "name": "Chile"},
  {"iso": "JOR", "name": "Jordan"},
  {"iso": "UKR", "name": "Ukraine"},
  {"iso": "BLM", "name": "Saint Barthelemy"},
  {"iso": "HUN", "name": "Hungary"},
  {"iso": "FRO", "name": "Faroe Islands"},
  {"iso": "GIB", "name": "Gibraltar"},
  {"iso": "LIE", "name": "Liechtenstein"},
  {"iso": "POL", "name": "Poland"},
  {"iso": "TUN", "name": "Tunisia"},
  {"iso": "PSE", "name": "West Bank and Gaza"},
  {"iso": "BIH", "name": "Bosnia and Herzegovina"},
  {"iso": "SVN", "name": "Slovenia"},
  {"iso": "ZAF", "name": "South Africa"},
  {"iso": "BTN", "name": "Bhutan"},
  {"iso": "CMR", "name": "Cameroon"},
  {"iso": "CRI", "name": "Costa Rica"},
  {"iso": "PER", "name": "Peru"},
  {"iso": "SRB", "name": "Serbia"},
  {"iso": "SVK", "name": "Slovakia"},
  {"iso": "TGO", "name": "Togo"},
  {"iso": "VAT", "name": "Holy See"},
  {"iso": "GUF", "name": "French Guiana"},
  {"iso": "MLT", "name": "Malta"},
  {"iso": "MTQ", "name": "Martinique"},
  {"iso": "BGR", "name": "Bulgaria"},
  {"iso": "MDV", "name": "Maldives"},
  {"iso": "BGD", "name": "Bangladesh"},
  {"iso": "MDA", "name": "Moldova"},
  {"iso": "PRY", "name": "Paraguay"},
  {"iso": "ALB", "name": "Albania"},
  {"iso": "CYP", "name": "Cyprus"},
  {"iso": "BRN", "name": "Brunei"},
  {"iso": "MAC", "name": "Macao SAR"},
  {"iso": "MAF", "name": "Saint Martin"},
  {"iso": "BFA", "name": "Burkina Faso"},
  {"iso": "GGY-JEY", "name": "Channel Islands"},
  {"iso": "MNG", "name": "Mongolia"},
  {"iso": "PAN", "name": "Panama"},
  {"iso": "cruise", "name": "Cruise Ship"},
  {"iso": "TWN", "name": "Taiwan*"},
  {"iso": "BOL", "name": "Bolivia"},
  {"iso": "HND", "name": "Honduras"},
  {"iso": "COD", "name": "Congo (Kinshasa)"},
  {"iso": "JAM", "name": "Jamaica"},
  {"iso": "REU", "name": "Reunion"},
  {"iso": "TUR", "name": "Turkey"},
  {"iso": "CUB", "name": "Cuba"},
  {"iso": "GUY", "name": "Guyana"},
  {"iso": "KAZ", "name": "Kazakhstan"},
  {"iso": "CYM", "name": "Cayman Islands"},
  {"iso": "GLP", "name": "Guadeloupe"},
  {"iso": "ETH", "name": "Ethiopia"},
  {"iso": "SDN", "name": "Sudan"},
  {"iso": "GIN", "name": "Guinea"},
  {"iso": "ATG", "name": "Antigua and Barbuda"},
  {"iso": "ABW", "name": "Aruba"},
  {"iso": "KEN", "name": "Kenya"},
  {"iso": "URY", "name": "Uruguay"},
  {"iso": "GHA", "name": "Ghana"},
  {"iso": "JEY", "name": "Jersey"},
  {"iso": "NAM", "name": "Namibia"},
  {"iso": "SYC", "name": "Seychelles"},
  {"iso": "TTO", "name": "Trinidad and Tobago"},
  {"iso": "VEN", "name": "Venezuela"},
  {"iso": "CUW", "name": "Curacao"},
  {"iso": "SWZ", "name": "Eswatini"},
  {"iso": "GAB", "name": "Gabon"},
  {"iso": "GTM", "name": "Guatemala"},
  {"iso": "GGY", "name": "Guernsey"},
  {"iso": "MRT", "name": "Mauritania"},
  {"iso": "RWA", "name": "Rwanda"},
  {"iso": "LCA", "name": "Saint Lucia"},
  {"iso": "VCT", "name": "Saint Vincent and the Grenadines"},
  {"iso": "SUR", "name": "Suriname"},
  {"iso": "RKS", "name": "Kosovo"},
  {"iso": "CAF", "name": "Central African Republic"},
  {"iso": "COG", "name": "Congo (Brazzaville)"},
  {"iso": "GNQ", "name": "Equatorial Guinea"},
  {"iso": "UZB", "name": "Uzbekistan"},
  {"iso": "GUM", "name": "Guam"},
  {"iso": "PRI", "name": "Puerto Rico"},
  {"iso": "BEN", "name": "Benin"},
  {"iso": "GRL", "name": "Greenland"},
  {"iso": "LBR", "name": "Liberia"},
  {"iso": "MYT", "name": "Mayotte"},
  {"iso": "SOM", "name": "Somalia"},
  {"iso": "TZA", "name": "Tanzania"},
  {"iso": "BHS", "name": "Bahamas"},
  {"iso": "BRB", "name": "Barbados"},
  {"iso": "MNE", "name": "Montenegro"},
  {"iso": "GMB", "name": "Gambia"},
  {"iso": "KGZ", "name": "Kyrgyzstan"},
  {"iso": "MUS", "name": "Mauritius"},
  {"iso": "ZMB", "name": "Zambia"},
  {"iso": "DJI", "name": "Djibouti"},
  {"iso": "TCD", "name": "Chad"},
  {"iso": "SLV", "name": "El Salvador"},
  {"iso": "FJI", "name": "Fiji"},
  {"iso": "NIC", "name": "Nicaragua"},
  {"iso": "MDG", "name": "Madagascar"},
  {"iso": "HTI", "name": "Haiti"},
  {"iso": "AGO", "name": "Angola"},
  {"iso": "CPV", "name": "Cabo Verde"},
  {"iso": "NER", "name": "Niger"},
  {"iso": "PNG", "name": "Papua New Guinea"},
  {"iso": "ZWE", "name": "Zimbabwe"},
  {"iso": "TLS", "name": "Timor-Leste"},
  {"iso": "ERI", "name": "Eritrea"},
  {"iso": "UGA", "name": "Uganda"},
  {"iso": "DMA", "name": "Dominica"},
  {"iso": "GRD", "name": "Grenada"},
  {"iso": "MOZ", "name": "Mozambique"},
  {"iso": "SYR", "name": "Syria"},
  {"iso": "BLZ", "name": "Belize"},
  {"iso": "LAO", "name": "Laos"},
  {"iso": "LBY", "name": "Libya"},
  {"iso": "NA-SHIP-DP", "name": "Diamond Princess"},
  {"iso": "GNB", "name": "Guinea-Bissau"},
  {"iso": "MLI", "name": "Mali"},
  {"iso": "KNA", "name": "Saint Kitts and Nevis"},
  {"iso": "BWA", "name": "Botswana"},
  {"iso": "BDI", "name": "Burundi"},
  {"iso": "SLE", "name": "Sierra Leone"},
  {"iso": "MMR", "name": "Burma"},
  {"iso": "MWI", "name": "Malawi"},
  {"iso": "SSD", "name": "South Sudan"},
  {"iso": "ESH", "name": "Western Sahara"},
  {"iso": "STP", "name": "Sao Tome and Principe"},
  {"iso": "NA-SHIP-MSZ", "name": "MS Zaandam"},
  {"iso": "YEM", "name": "Yemen"},
  {"iso": "COM", "name": "Comoros"},
  {"iso": "TJK", "name": "Tajikistan"},
  {"iso": "LSO", "name": "Lesotho"},
  {"iso": "SLB", "name": "Solomon Islands"},
  {"iso": "MHL", "name": "Marshall Islands"},
  {"iso": "VUT", "name": "Vanuatu"},
  {"iso": "WSM", "name": "Samoa"},
  {"iso": "KIR", "name": "Kiribati"},
  {"iso": "PLW", "name": "Palau"},
  {"iso": "TON", "name": "Tonga"}
];

List worldCountries = [
  {"Country": "Afghanistan", "ThreeLetterSymbol": "afg"},
  {"Country": "Albania", "ThreeLetterSymbol": "alb"},
  {"Country": "Algeria", "ThreeLetterSymbol": "dza"},
  {"Country": "Andorra", "ThreeLetterSymbol": "and"},
  {"Country": "Angola", "ThreeLetterSymbol": "ago"},
  {"Country": "Anguilla", "ThreeLetterSymbol": "aia"},
  {"Country": "Antigua and Barbuda", "ThreeLetterSymbol": "atg"},
  {"Country": "Argentina", "ThreeLetterSymbol": "arg"},
  {"Country": "Armenia", "ThreeLetterSymbol": "arm"},
  {"Country": "Aruba", "ThreeLetterSymbol": "abw"},
  {"Country": "Australia", "ThreeLetterSymbol": "aus"},
  {"Country": "Austria", "ThreeLetterSymbol": "aut"},
  {"Country": "Azerbaijan", "ThreeLetterSymbol": "aze"},
  {"Country": "Bahamas", "ThreeLetterSymbol": "bhs"},
  {"Country": "Bahrain", "ThreeLetterSymbol": "bhr"},
  {"Country": "Bangladesh", "ThreeLetterSymbol": "bgd"},
  {"Country": "Barbados", "ThreeLetterSymbol": "brb"},
  {"Country": "Belarus", "ThreeLetterSymbol": "blr"},
  {"Country": "Belgium", "ThreeLetterSymbol": "bel"},
  {"Country": "Belize", "ThreeLetterSymbol": "blz"},
  {"Country": "Benin", "ThreeLetterSymbol": "ben"},
  {"Country": "Bermuda", "ThreeLetterSymbol": "bmu"},
  {"Country": "Bhutan", "ThreeLetterSymbol": "btn"},
  {"Country": "Bolivia", "ThreeLetterSymbol": "bol"},
  {"Country": "Bosnia and Herzegovina", "ThreeLetterSymbol": "bih"},
  {"Country": "Botswana", "ThreeLetterSymbol": "bwa"},
  {"Country": "Brazil", "ThreeLetterSymbol": "bra"},
  {"Country": "British Virgin Islands", "ThreeLetterSymbol": "vgb"},
  {"Country": "Brunei", "ThreeLetterSymbol": "brn"},
  {"Country": "Bulgaria", "ThreeLetterSymbol": "bgr"},
  {"Country": "Burkina Faso", "ThreeLetterSymbol": "bfa"},
  {"Country": "Burundi", "ThreeLetterSymbol": "bdi"},
  {"Country": "Cabo Verde", "ThreeLetterSymbol": "cpv"},
  {"Country": "Cambodia", "ThreeLetterSymbol": "khm"},
  {"Country": "Cameroon", "ThreeLetterSymbol": "cmr"},
  {"Country": "Canada", "ThreeLetterSymbol": "can"},
  {"Country": "CAR", "ThreeLetterSymbol": "caf"},
  {"Country": "Caribbean Netherlands", "ThreeLetterSymbol": "bes"},
  {"Country": "Cayman Islands", "ThreeLetterSymbol": "cym"},
  {"Country": "Chad", "ThreeLetterSymbol": "tcd"},
  {"Country": "Channel Islands", "ThreeLetterSymbol": "usa"},
  {"Country": "Chile", "ThreeLetterSymbol": "chl"},
  {"Country": "China", "ThreeLetterSymbol": "chn"},
  {"Country": "Colombia", "ThreeLetterSymbol": "col"},
  {"Country": "Comoros", "ThreeLetterSymbol": "com"},
  {"Country": "Congo", "ThreeLetterSymbol": "cog"},
  {"Country": "Costa Rica", "ThreeLetterSymbol": "cri"},
  {"Country": "Croatia", "ThreeLetterSymbol": "hrv"},
  {"Country": "Cuba", "ThreeLetterSymbol": "cub"},
  {"Country": "Cura??ao", "ThreeLetterSymbol": "cuw"},
  {"Country": "Cyprus", "ThreeLetterSymbol": "cyp"},
  {"Country": "Czechia", "ThreeLetterSymbol": "cze"},
  {"Country": "Denmark", "ThreeLetterSymbol": "dnk"},
  {"Country": "Diamond Princess", "ThreeLetterSymbol": "usa"},
  {"Country": "Djibouti", "ThreeLetterSymbol": "dji"},
  {"Country": "Dominica", "ThreeLetterSymbol": "dma"},
  {"Country": "Dominican Republic", "ThreeLetterSymbol": "dom"},
  {"Country": "DRC", "ThreeLetterSymbol": "cod"},
  {"Country": "Ecuador", "ThreeLetterSymbol": "ecu"},
  {"Country": "Egypt", "ThreeLetterSymbol": "egy"},
  {"Country": "El Salvador", "ThreeLetterSymbol": "slv"},
  {"Country": "Equatorial Guinea", "ThreeLetterSymbol": "gnq"},
  {"Country": "Eritrea", "ThreeLetterSymbol": "eri"},
  {"Country": "Estonia", "ThreeLetterSymbol": "est"},
  {"Country": "Eswatini", "ThreeLetterSymbol": "swz"},
  {"Country": "Ethiopia", "ThreeLetterSymbol": "eth"},
  {"Country": "Faeroe Islands", "ThreeLetterSymbol": "fro"},
  {"Country": "Falkland Islands", "ThreeLetterSymbol": "flk"},
  {"Country": "Fiji", "ThreeLetterSymbol": "fji"},
  {"Country": "Finland", "ThreeLetterSymbol": "fin"},
  {"Country": "France", "ThreeLetterSymbol": "fra"},
  {"Country": "French Guiana", "ThreeLetterSymbol": "guf"},
  {"Country": "French Polynesia", "ThreeLetterSymbol": "pyf"},
  {"Country": "Gabon", "ThreeLetterSymbol": "gab"},
  {"Country": "Gambia", "ThreeLetterSymbol": "gmb"},
  {"Country": "Georgia", "ThreeLetterSymbol": "geo"},
  {"Country": "Germany", "ThreeLetterSymbol": "deu"},
  {"Country": "Ghana", "ThreeLetterSymbol": "gha"},
  {"Country": "Gibraltar", "ThreeLetterSymbol": "gib"},
  {"Country": "Greece", "ThreeLetterSymbol": "grc"},
  {"Country": "Greenland", "ThreeLetterSymbol": "grl"},
  {"Country": "Grenada", "ThreeLetterSymbol": "grd"},
  {"Country": "Guadeloupe", "ThreeLetterSymbol": "glp"},
  {"Country": "Guatemala", "ThreeLetterSymbol": "gtm"},
  {"Country": "Guinea", "ThreeLetterSymbol": "gin"},
  {"Country": "Guinea-Bissau", "ThreeLetterSymbol": "gnb"},
  {"Country": "Guyana", "ThreeLetterSymbol": "guy"},
  {"Country": "Haiti", "ThreeLetterSymbol": "hti"},
  {"Country": "Honduras", "ThreeLetterSymbol": "hnd"},
  {"Country": "Hong Kong", "ThreeLetterSymbol": "hkg"},
  {"Country": "Hungary", "ThreeLetterSymbol": "hun"},
  {"Country": "Iceland", "ThreeLetterSymbol": "isl"},
  {"Country": "India", "ThreeLetterSymbol": "ind"},
  {"Country": "Indonesia", "ThreeLetterSymbol": "idn"},
  {"Country": "Iran", "ThreeLetterSymbol": "irn"},
  {"Country": "Iraq", "ThreeLetterSymbol": "irq"},
  {"Country": "Ireland", "ThreeLetterSymbol": "irl"},
  {"Country": "Isle of Man", "ThreeLetterSymbol": "imn"},
  {"Country": "Israel", "ThreeLetterSymbol": "isr"},
  {"Country": "Italy", "ThreeLetterSymbol": "ita"},
  {"Country": "Ivory Coast", "ThreeLetterSymbol": "civ"},
  {"Country": "Jamaica", "ThreeLetterSymbol": "jam"},
  {"Country": "Japan", "ThreeLetterSymbol": "jpn"},
  {"Country": "Jordan", "ThreeLetterSymbol": "jor"},
  {"Country": "Kazakhstan", "ThreeLetterSymbol": "kaz"},
  {"Country": "Kenya", "ThreeLetterSymbol": "ken"},
  {"Country": "Kuwait", "ThreeLetterSymbol": "kwt"},
  {"Country": "Kyrgyzstan", "ThreeLetterSymbol": "kgz"},
  {"Country": "Laos", "ThreeLetterSymbol": "lao"},
  {"Country": "Latvia", "ThreeLetterSymbol": "lva"},
  {"Country": "Lebanon", "ThreeLetterSymbol": "lbn"},
  {"Country": "Lesotho", "ThreeLetterSymbol": "lso"},
  {"Country": "Liberia", "ThreeLetterSymbol": "lbr"},
  {"Country": "Libya", "ThreeLetterSymbol": "lby"},
  {"Country": "Liechtenstein", "ThreeLetterSymbol": "lie"},
  {"Country": "Lithuania", "ThreeLetterSymbol": "ltu"},
  {"Country": "Luxembourg", "ThreeLetterSymbol": "lux"},
  {"Country": "Macao", "ThreeLetterSymbol": "mac"},
  {"Country": "Madagascar", "ThreeLetterSymbol": "mdg"},
  {"Country": "Malawi", "ThreeLetterSymbol": "mwi"},
  {"Country": "Malaysia", "ThreeLetterSymbol": "mys"},
  {"Country": "Maldives", "ThreeLetterSymbol": "mdv"},
  {"Country": "Mali", "ThreeLetterSymbol": "mli"},
  {"Country": "Malta", "ThreeLetterSymbol": "mlt"},
  {"Country": "Marshall Islands", "ThreeLetterSymbol": "mhl"},
  {"Country": "Martinique", "ThreeLetterSymbol": "mtq"},
  {"Country": "Mauritania", "ThreeLetterSymbol": "mrt"},
  {"Country": "Mauritius", "ThreeLetterSymbol": "mus"},
  {"Country": "Mayotte", "ThreeLetterSymbol": "myt"},
  {"Country": "Mexico", "ThreeLetterSymbol": "mex"},
  {"Country": "Moldova", "ThreeLetterSymbol": "mda"},
  {"Country": "Monaco", "ThreeLetterSymbol": "mco"},
  {"Country": "Mongolia", "ThreeLetterSymbol": "mng"},
  {"Country": "Montenegro", "ThreeLetterSymbol": "mne"},
  {"Country": "Montserrat", "ThreeLetterSymbol": "msr"},
  {"Country": "Morocco", "ThreeLetterSymbol": "mar"},
  {"Country": "Mozambique", "ThreeLetterSymbol": "moz"},
  {"Country": "MS Zaandam", "ThreeLetterSymbol": "usa"},
  {"Country": "Myanmar", "ThreeLetterSymbol": "mmr"},
  {"Country": "Namibia", "ThreeLetterSymbol": "nam"},
  {"Country": "Nepal", "ThreeLetterSymbol": "npl"},
  {"Country": "Netherlands", "ThreeLetterSymbol": "nld"},
  {"Country": "New Caledonia", "ThreeLetterSymbol": "ncl"},
  {"Country": "New Zealand", "ThreeLetterSymbol": "nzl"},
  {"Country": "Nicaragua", "ThreeLetterSymbol": "nic"},
  {"Country": "Niger", "ThreeLetterSymbol": "ner"},
  {"Country": "Nigeria", "ThreeLetterSymbol": "nga"},
  {"Country": "North Macedonia", "ThreeLetterSymbol": "mkd"},
  {"Country": "Norway", "ThreeLetterSymbol": "nor"},
  {"Country": "Oman", "ThreeLetterSymbol": "omn"},
  {"Country": "Pakistan", "ThreeLetterSymbol": "pak"},
  {"Country": "Palestine", "ThreeLetterSymbol": "pse"},
  {"Country": "Panama", "ThreeLetterSymbol": "pan"},
  {"Country": "Papua New Guinea", "ThreeLetterSymbol": "png"},
  {"Country": "Paraguay", "ThreeLetterSymbol": "pry"},
  {"Country": "Peru", "ThreeLetterSymbol": "per"},
  {"Country": "Philippines", "ThreeLetterSymbol": "phl"},
  {"Country": "Poland", "ThreeLetterSymbol": "pol"},
  {"Country": "Portugal", "ThreeLetterSymbol": "prt"},
  {"Country": "Qatar", "ThreeLetterSymbol": "qat"},
  {"Country": "R??union", "ThreeLetterSymbol": "reu"},
  {"Country": "Romania", "ThreeLetterSymbol": "rou"},
  {"Country": "Russia", "ThreeLetterSymbol": "rus"},
  {"Country": "Rwanda", "ThreeLetterSymbol": "rwa"},
  {"Country": "Saint Kitts and Nevis", "ThreeLetterSymbol": "kna"},
  {"Country": "Saint Lucia", "ThreeLetterSymbol": "lca"},
  {"Country": "Saint Martin", "ThreeLetterSymbol": "maf"},
  {"Country": "Saint Pierre Miquelon", "ThreeLetterSymbol": "spm"},
  {"Country": "San Marino", "ThreeLetterSymbol": "smr"},
  {"Country": "Sao Tome and Principe", "ThreeLetterSymbol": "stp"},
  {"Country": "Saudi Arabia", "ThreeLetterSymbol": "sau"},
  {"Country": "Senegal", "ThreeLetterSymbol": "sen"},
  {"Country": "Serbia", "ThreeLetterSymbol": "srb"},
  {"Country": "Seychelles", "ThreeLetterSymbol": "syc"},
  {"Country": "Sierra Leone", "ThreeLetterSymbol": "sle"},
  {"Country": "Singapore", "ThreeLetterSymbol": "sgp"},
  {"Country": "Sint Maarten", "ThreeLetterSymbol": "sxm"},
  {"Country": "S. Korea", "ThreeLetterSymbol": "kor"},
  {"Country": "Slovakia", "ThreeLetterSymbol": "svk"},
  {"Country": "Slovenia", "ThreeLetterSymbol": "svn"},
  {"Country": "Solomon Islands", "ThreeLetterSymbol": "slb"},
  {"Country": "Somalia", "ThreeLetterSymbol": "som"},
  {"Country": "South Africa", "ThreeLetterSymbol": "zaf"},
  {"Country": "South Sudan", "ThreeLetterSymbol": "ssd"},
  {"Country": "Spain", "ThreeLetterSymbol": "esp"},
  {"Country": "Sri Lanka", "ThreeLetterSymbol": "lka"},
  {"Country": "St. Barth", "ThreeLetterSymbol": "blm"},
  {"Country": "St. Vincent Grenadines", "ThreeLetterSymbol": "vct"},
  {"Country": "Sudan", "ThreeLetterSymbol": "sdn"},
  {"Country": "Suriname", "ThreeLetterSymbol": "sur"},
  {"Country": "Sweden", "ThreeLetterSymbol": "swe"},
  {"Country": "Switzerland", "ThreeLetterSymbol": "che"},
  {"Country": "Syria", "ThreeLetterSymbol": "syr"},
  {"Country": "Taiwan", "ThreeLetterSymbol": "twn"},
  {"Country": "Tajikistan", "ThreeLetterSymbol": "tjk"},
  {"Country": "Tanzania", "ThreeLetterSymbol": "tza"},
  {"Country": "Thailand", "ThreeLetterSymbol": "tha"},
  {"Country": "Timor-Leste", "ThreeLetterSymbol": "tls"},
  {"Country": "Togo", "ThreeLetterSymbol": "tgo"},
  {"Country": "Trinidad and Tobago", "ThreeLetterSymbol": "tto"},
  {"Country": "Tunisia", "ThreeLetterSymbol": "tun"},
  {"Country": "Turkey", "ThreeLetterSymbol": "tur"},
  {"Country": "Turks and Caicos", "ThreeLetterSymbol": "tca"},
  {"Country": "UAE", "ThreeLetterSymbol": "are"},
  {"Country": "Uganda", "ThreeLetterSymbol": "uga"},
  {"Country": "UK", "ThreeLetterSymbol": "gbr"},
  {"Country": "Ukraine", "ThreeLetterSymbol": "ukr"},
  {"Country": "Uruguay", "ThreeLetterSymbol": "ury"},
  {"Country": "USA", "ThreeLetterSymbol": "usa"},
  {"Country": "Uzbekistan", "ThreeLetterSymbol": "uzb"},
  {"Country": "Vanuatu", "ThreeLetterSymbol": "vut"},
  {"Country": "Vatican City", "ThreeLetterSymbol": "vat"},
  {"Country": "Venezuela", "ThreeLetterSymbol": "ven"},
  {"Country": "Vietnam", "ThreeLetterSymbol": "vnm"},
  {"Country": "Wallis and Futuna", "ThreeLetterSymbol": "wlf"},
  {"Country": "Western Sahara", "ThreeLetterSymbol": "esh"},
  {"Country": "Yemen", "ThreeLetterSymbol": "yem"},
  {"Country": "Zambia", "ThreeLetterSymbol": "zmb"},
  {"Country": "Zimbabwe", "ThreeLetterSymbol": "zwe"}
];

Future<void> getandUpdateUsersData() async {
  FirebaseMessaging.instance.getToken().then((token) {
    initMessages();
    FirebaseFirestore.instance
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({
      'token': token,
    }).then((value) {
      print("Done");
      FirebaseFirestore.instance
          .collection('Users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .snapshots()
          .listen((value) {
        print("Getting data");
        currentUser = value;
        currentUserData.value = Map.from(value.data()!);
        if (firstOpen == false) {
          getNearestLabs(currentUserData['labRadius']);
          getMyChats();
          getBlogs();
          showVaccinationForm();
          getVaccineData();
          getAdminDetails();
          // updateIsolationDays();
          firstOpen = true;
          // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Home()));
          Get.off(() => MainNav());
        }
      });
    });
  });
}

updateIsolationDays() {
  FirebaseFirestore.instance.collection("Users").get().then((value) {
    value.docs.forEach((element) {
      FirebaseFirestore.instance.collection("Users").doc(element.id).update({
        'sos_contacts': [],
        'isolatedOn': null,
      });
    });
  });
}

getAdminDetails() {
  FirebaseFirestore.instance
      .collection("Admin")
      .doc('Admin Details')
      .snapshots()
      .listen((value) {
    adminDetails.value = value.data()!;
  });
}

isolationPillButton(text, onTap) {
  return InkWell(
    onTap: onTap,
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(35),
        border: Border.all(
          color: Colors.white,
          width: 0.6,
        ),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 10,
      ),
      child: montserratText(
        text: text,
        color: Colors.white,
        size: 13,
        weight: FontWeight.w500,
      ),
    ),
  );
}

getVaccineData() {
  FirebaseFirestore.instance.collection("Vaccinations").get().then((value) {
    value.docs.forEach((element) {
      print(vaccData.value[element.get('vaccine')]);
      vaccData.value[element.get('vaccine')] =
          vaccData.value[element.get('vaccine')] + element.get('reCovidCount');
      // if (!vaccData.value.containsKey(element.get('vaccine'))) {
      //   vaccData.value.addAll({
      //     element.get('vaccine'): element.get('reCovidCount'),
      //   });
      // } else {

      // }
    });

    print("Vaccs here: ${vaccData.value}");
  });
}

void showVaccinationForm() {
  if (!currentUserData['hadFirstVacc']) {
    Timer(const Duration(seconds: 0), () {
      Get.defaultDialog(
        confirm: Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: () {
              if (1 != 1) {
              } else {
                if (vaccinated.value) {
                  FirebaseFirestore.instance
                      .collection("Vaccinations")
                      .doc(currentUser.id)
                      .set({
                    'date': DateTime.now(),
                    'dateVaccinated': dateVaccinated.value,
                    'notes': covidNotes.text.trim(),
                    'reCovidCount': reCovid.value ? 1 : 0,
                    'vaccine': selectedVaccine.value,
                    'user': currentUser.id,
                    'triMonthlyData': [],
                  }).then((value) {
                    FirebaseFirestore.instance
                        .collection("Users")
                        .doc(currentUser.id)
                        .update({
                      'hadFirstVacc': true,
                    });
                  });
                  Get.back();
                } else {
                  FirebaseFirestore.instance
                      .collection("Users")
                      .doc(currentUser.id)
                      .update({
                    'hadFirstVacc': true,
                  });
                  Get.back();
                }
              }
            },
            child: montserratText(
              text: "Confirm",
              color: primaryColor,
              size: 13,
              weight: FontWeight.w400,
            ),
          ),
        ),
        cancel: InkWell(
          onTap: () {
            Get.back();
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: montserratText(
              text: "Cancel",
              color: Colors.grey,
              size: 13,
              weight: FontWeight.w400,
            ),
          ),
        ),
        title: "Hol'up!",
        contentPadding: const EdgeInsets.all(15),
        middleText: "We'd like your vaccination data",
        content: Obx(() {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                montserratText(
                  text:
                      "We need your help, we're collecting data for vaccinations",
                  size: 12,
                  color: Colors.grey,
                  weight: FontWeight.w300,
                  align: TextAlign.start,
                ),
                const SizedBox(
                  height: 10,
                ),
                SwitchListTile(
                  value: vaccinated.value,
                  contentPadding: const EdgeInsets.all(0),
                  onChanged: (val) {
                    vaccinated.value = val;
                  },
                  activeColor: primaryColor,
                  title: montserratText(
                    text: "Have you been vaccinated yet?",
                    size: 13,
                    color: Colors.black,
                    weight: FontWeight.w400,
                  ),
                ),
                vaccinated.value
                    ? Column(
                        children: [
                          const SizedBox(
                            height: 15,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.white,
                              boxShadow: [
                                boxShad(0, 0, 30),
                              ],
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton(
                                isExpanded: true,
                                value: selectedVaccine.value,
                                hint: montserratText(
                                  text: "Select Vaccine",
                                  color: Colors.grey,
                                  size: 13,
                                  weight: FontWeight.w400,
                                ),
                                items:
                                    vaccines.map<DropdownMenuItem<String>>((e) {
                                  return DropdownMenuItem(
                                    child: montserratText(
                                      text: e,
                                      size: 13,
                                      color: Colors.black,
                                      weight: FontWeight.w400,
                                    ),
                                    value: e,
                                  );
                                }).toList(),
                                onChanged: (val) {
                                  selectedVaccine.value = val;
                                },
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          InkWell(
                            onTap: () {
                              showDatePicker(
                                      context: Get.context!,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(2018),
                                      lastDate: DateTime.now())
                                  .then((value) {
                                dateVaccinated.value = value;
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.white,
                                boxShadow: [
                                  boxShad(0, 0, 30),
                                ],
                              ),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: TextField(
                                enabled: false,
                                style: GoogleFonts.montserrat(
                                  fontSize: 13,
                                ),
                                controller: dateVaccinated.value == null
                                    ? null
                                    : TextEditingController(
                                        text: DateFormat('dd-MMM-yyyy')
                                            .format(dateVaccinated.value),
                                      ),
                                decoration: InputDecoration(
                                  hintText: "Date of Vaccination",
                                  hintStyle: GoogleFonts.montserrat(
                                    color: Colors.grey,
                                    fontSize: 13,
                                  ),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          SwitchListTile(
                            value: reCovid.value,
                            contentPadding: const EdgeInsets.all(0),
                            onChanged: (val) {
                              reCovid.value = val;
                            },
                            activeColor: primaryColor,
                            title: montserratText(
                              text: "Did you get Covid after being vaccinated?",
                              size: 13,
                              align: TextAlign.start,
                              color: Colors.black,
                              weight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          reCovid.value
                              ? Container(
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 0),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 25, vertical: 10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(21),
                                    color: Colors.white,
                                    boxShadow: [
                                      boxShad(0, 0, 50),
                                    ],
                                  ),
                                  child: TextField(
                                    enabled: true,
                                    autofocus: true,
                                    controller: covidNotes,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Any notes on your experience",
                                      hintStyle: GoogleFonts.montserrat(
                                        color: Colors.grey.withOpacity(0.7),
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                )
                              : Container(),
                        ],
                      )
                    : Container(),
              ],
            ),
          );
        }),
      );
    });
  } else {
    getVaccData();
  }
}

getVaccData() {}

void initMessages() {
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Got a message whilst in the foreground!');
    print('Message data: ${message.data}');
    if (message.notification != null) {
      Get.snackbar(message.notification!.title!, message.notification!.body!);
      print(
          'Message also contained a notification: ${message.notification!.body}');
    }
  });
}

sendNotif(title, body, token) {
  http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "key=$cloudNotifkey"
      },
      body: jsonEncode({
        "to": token,
        "notification": {
          "title": title,
          "body": body,
          "mutable_content": true,
          "sound": "Tri-tone"
        },
        "data": {
          "url": "<url of media image>",
          "dl": "<deeplink action on tap of notification>"
        }
      }));
}

getBlogs() {
  FirebaseFirestore.instance.collection("Diets").get().then((value) {
    diets.value = value.docs;
  });
}

getMyChats() {
  print("Getting chats");
  FirebaseFirestore.instance
      .collection("Chats")
      .where('users', arrayContainsAny: [currentUser.id])
      .snapshots()
      .listen((value) {
        print("OOF");
        print(value.docs);
        chats.value = value.docs;
      });
}

getNearestLabs(distance) {
  FirebaseFirestore.instance.collection("Labs").snapshots().listen((value) {
    print("got change");
    labs.value = [];
    value.docs.forEach((element) {
      var dist = Geolocator.distanceBetween(
        currentLocation.latitude,
        currentLocation.longitude,
        element.get('geometry')['location']['lat'],
        element.get('geometry')['location']['lng'],
      );
      print(dist / 1000);
      if ((dist / 1000) <= distance) {
        labs.value.add(element);
      }
    });
    print("Labs are: ${labs.value}");
    if (labs.value.length <= 2 && labSearchedOnce == false) {
      labSearchedOnce = true;
      print("Labs problem: ${labs.value.length}");
      scrapeFromApi(currentLocation.latitude, currentLocation.longitude);
    }
  });
}

void scrapeFromApi(double latitude, double longitude) {
  print("Called");
  http
      .get(Uri.parse("http://67.202.27.245:8080/scrape/$latitude/$longitude"))
      .then((value) {});
}

headingWidget(text, {color = Colors.white, showViewAll = true}) {
  return Padding(
    padding: const EdgeInsets.only(right: 10),
    child: showViewAll
        ? Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              montserratText(
                align: TextAlign.start,
                text: text,
                size: 18,
                color: color,
                weight: FontWeight.w300,
              ),
              montserratText(
                align: TextAlign.start,
                text: "View All",
                size: 13,
                color: primaryColor.withOpacity(0.8),
                weight: FontWeight.w300,
              )
            ],
          )
        : montserratText(
            align: TextAlign.start,
            text: text,
            size: 18,
            color: color,
            weight: FontWeight.w300,
          ),
  );
}

Widget LabWidget(e, context) {
  return Container(
    height: MediaQuery.of(context).size.height * 0.25,
    width: MediaQuery.of(context).size.width * 0.86,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(18),
      color: Colors.white,
      boxShadow: [
        boxShad(5, 7, 10, opacity: 0.15),
      ],
    ),
    margin: const EdgeInsets.only(
      right: 15,
      left: 15,
      bottom: 18,
    ),
    child: Row(
      children: [
        Expanded(
          flex: 3,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(18),
                bottomLeft: Radius.circular(18),
              ),
              image: e.get('photo') != null
                  ? DecorationImage(
                      image: MemoryImage(
                        e.get('photo').bytes,
                      ),
                      fit: BoxFit.cover,
                    )
                  : const DecorationImage(
                      image: AssetImage(
                        'Assets/userAvatar.png',
                      ),
                    ),
            ),
          ),
        ),
        Expanded(
          flex: 4,
          child: Container(
            padding: const EdgeInsets.only(left: 15, top: 15, right: 10),
            child: Column(
              children: [
                montserratText(
                  text: e.get('name'),
                  size: 15,
                  weight: FontWeight.w500,
                  color: Colors.black,
                  align: TextAlign.start,
                ),
                const SizedBox(
                  height: 5,
                ),
                montserratText(
                  text: e.get('formatted_address'),
                  size: 12,
                  weight: FontWeight.w400,
                  color: Colors.grey,
                  align: TextAlign.start,
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 18),
                  child: Row(
                    // mainAxisAlignment:
                    //     MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.star,
                            size: 14,
                            color: primaryColor,
                          ),
                          montserratText(
                            text: e.get('rating') == null
                                ? "0.0"
                                : e.get('rating').toString(),
                            color: primaryColor,
                            size: 12,
                            weight: FontWeight.w400,
                          )
                        ],
                      ),
                      montserratText(
                        text: e.get('user_ratings_total') == null
                            ? "(0)"
                            : " (${e.get('user_ratings_total').toString()})",
                        color: primaryColor,
                        size: 12,
                        weight: FontWeight.w400,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

boxShad(double x, double y, double b, {opacity = 0.4}) {
  return BoxShadow(
    offset: Offset(x, y),
    blurRadius: b,
    color: secondaryColor.withOpacity(opacity),
  );
}

Future<Position> getCurrentLocation() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  // serviceEnabled = await Geolocator.isLocationServiceEnabled();
  // if (!serviceEnabled) {
  //   // Location services are not enabled don't continue
  //   // accessing the position and request users of the
  //   // App to enable the location services.
  //   await Geolocator.openLocationSettings();
  //   return Future.error('Location services are disabled.');
  // }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately.
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }

  // When we reach here, permissions are granted and we can
  // continue accessing the position of the device.
  return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);
}

getPage(page) {
  switch (page) {
    case 'home':
      return {
        'type': 'index',
        'value': 1,
      };
    case 'labs':
      if (currentUserData['isolated']) {
        return {
          'type': 'page',
          'value': const Laboratories(),
        };
      } else {
        return {
          'type': 'index',
          'value': 2,
        };
      }
    case 'profile':
      return {
        'type': 'index',
        'value': 2,
      };
    case 'settings':
      return {
        'type': 'index',
        'value': 2,
      };
    case 'signup':
      return {
        'type': 'page',
        'value': const Login(),
      };
  }
}

errorSnack(msg) {
  return Get.snackbar(
    "Error",
    msg,
    backgroundColor: Colors.redAccent.withOpacity(0.5),
  );
}

successSnack(msg, {title = "Success"}) {
  return Get.snackbar(
    title,
    msg,
    backgroundColor: Colors.lightGreen.withOpacity(0.5),
  );
}

Widget montserratText(
    {text,
    weight = FontWeight.w700,
    double size = 21,
    align = TextAlign.center,
    color = const Color(0xff68B2A0)}) {
  return Text(
    text,
    style: GoogleFonts.montserrat(
      fontWeight: weight,
      fontSize: size,
      color: color,
    ),
    textAlign: align,
  );
}

gradientLongButton({text, onTap, double horizontal = 40}) {
  return InkWell(
    onTap: onTap,
    child: Container(
      margin: EdgeInsets.symmetric(horizontal: horizontal, vertical: 10),
      padding: const EdgeInsets.symmetric(vertical: 17),
      decoration: BoxDecoration(
        boxShadow: [boxShad(5, 5, 20)],
        borderRadius: BorderRadius.circular(21),
        gradient: LinearGradient(
          colors: [
            primaryColor,
            secondaryColor,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Center(
        child: montserratText(
            text: text, size: 13, color: Colors.white, weight: FontWeight.w700),
      ),
    ),
  );
}

longButton({text, onTap, icon}) {
  return InkWell(
    onTap: onTap,
    child: Container(
      margin: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
      padding: EdgeInsets.symmetric(vertical: 17),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [boxShad(5, 5, 20)],
        borderRadius: BorderRadius.circular(21),
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            SizedBox(
              width: 18,
            ),
            montserratText(
                text: text,
                size: 15,
                color: primaryColor,
                weight: FontWeight.w500)
          ],
        ),
      ),
    ),
  );
}

loginInputField({
  hint,
  @required controller,
  double horizontal = 30,
  obscure = false,
  enabled = true,
}) {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: horizontal),
    padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(21),
      color: Colors.white,
      boxShadow: [
        boxShad(0, 0, 50),
      ],
    ),
    child: TextField(
      enabled: enabled,
      autofocus: true,
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: hint,
        hintStyle: GoogleFonts.montserrat(color: Colors.grey.withOpacity(0.7)),
      ),
    ),
  );
}

Widget shadedListTile({title, subtitle, onTap}) {
  return Column(
    children: [
      Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: [
            boxShad(5, 7, 10, opacity: 0.15),
          ],
        ),
        child: ListTile(
          onTap: onTap,
          title: montserratText(
            text: title,
            color: Colors.black,
            align: TextAlign.start,
            size: 17,
          ),
          subtitle: montserratText(
            text: subtitle,
            size: 13,
            align: TextAlign.start,
            color: Colors.grey[500],
            weight: FontWeight.w400,
          ),
          trailing: const Icon(
            Icons.navigate_next_rounded,
            size: 30,
          ),
        ),
      ),
      const SizedBox(
        height: 15,
      ),
    ],
  );
}

gradientAppBar({@required context, title}) {
  return Container(
    height: MediaQuery.of(context).size.height * 0.15,
    padding: EdgeInsets.symmetric(horizontal: 15),
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [primaryColor, secondaryColor],
        begin: Alignment.topLeft,
      ),
      boxShadow: [boxShad(5, 5, 25)],
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(25),
        bottomRight: Radius.circular(25),
      ),
    ),
    child: Center(
      child: Row(
        children: [
          InkWell(
            onTap: () {
              Get.back();
            },
            child: const Icon(
              Icons.navigate_before,
              size: 30,
              color: Colors.white,
            ),
          ),
          const SizedBox(
            width: 15,
          ),
          montserratText(
            text: title,
            color: Colors.white,
            size: 20,
            weight: FontWeight.w500,
          ),
        ],
      ),
    ),
  );
}
