<?php

/**
 * @defgroup submission
 */

/**
 * @file JELCodes.inc.php
 *
 * Copyright (c) 2017 Dominik Blaha
 *  Inspiration from John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * @class JELCodes
 * @ingroup submission
 *
 * @brief Class for manipulating JEL codes.
 */

//$Id$

import('db.DBConnection');

class JELCodes {

	// Database connection object
	private $_dataSource;

	// JEL classification
	private $JELClassification = array();

  /**
  * Constructor.
  * Initalization the connection to database.
  *
  */
  function __construct(){
    if (!isset($dataSource)) {
			$this->_dataSource =& DBConnection::getConn();
		} else {
			$this->_dataSource = $dataSource;
		}
		$this->init();
  }

	/**
	*	Returns an associative array with values for the select drop down list
	*	@return array
	*/
	function getClassification(){
		if(!empty($this->JELClassification)) return $this->JELClassification;
	}

	/**
	*	Returns a keyword for a given code
	* @return string
	*/
	function getKeyword($code){
		foreach ($this->JELClassification as $key => $optgroup) {
			foreach ($optgroup as $JELCode => $keyword) {
				if($JELCode === $code){
					return $keyword;
				}
			}
		}
		error_log("Error while getting JEL keyword: Key not found.");
		return false;
	}

  /**
	 * Returns an associative array with matching rows from the db for the paper
	 * @param $paper object
   * @return array
	 */
	function getCodes($paperID) {
    $conn = $this->_dataSource;
    if (isset($paperID)){
      $codes = $conn->Execute('SELECT * FROM paper_jel_codes WHERE paper_id = ?', array($paperID));
      if (!$codes) {
         print $conn->ErrorMsg();
       }
      else {
        $temp = array();
        //print "<pre>";
        while (!$codes->EOF) {
            //print $codes->fields[0].' '.$codes->fields[1]. ' ' . $codes->fields[2] . '<BR>';
            $temp[] = $codes->fields;
            $codes->MoveNext();
        }    $codes->Close(); # optional
        //print "</pre>";
        return $temp;
      }
    }
    else {
      error_log("Error while getting JEL codes: PaperID not set up.");
      return NULL;
    }

	}

	/**
	*	Sets up JEL code for given paper
	*	@param $paper_id ID of the paper to set up JEL code
	*	@param $code Code of the JEL keyword
	*	@param $keyword Classification keyword
	*/
	function setCode($paper_id, $key, $keyword){
		$conn = $this->_dataSource;
		if(isset($paper_id)){
			if(isset($key)){
				if(isset($keyword)){
					$sql = "INSERT INTO `paper_jel_codes`(`paper_id`, `code`, `code_keyword`) VALUES (?,?,?)";
					$err = $conn->Execute($sql, array($paper_id, $key, $keyword));
					if($err === false){
						error_log("Error while inserting JEL code: " . $conn->ErrorMsg());
					}
				}
				else {
					error_log("Error while setting up JEL code: keyword not set up.");
					return false;
				}
			}
			else {
				error_log("Error while setting up JEL code: key not set up.");
				return false;
			}
		}
		else {
			error_log("Error while setting up JEL code: Paper ID not set up.");
			return false;
		}
	}

	/**
	*	Sets up the array with JEL Classification for the select in form
	*/
	function init(){
		$classification = array();
		$temp["A General Economics and Teaching"] = array();
		$temp["&nbsp;&nbsp;General Economics"] = array(
			"A10" => "General",
			"A11" => "Role of Economics / Role of Economists / Market for Economists",
			"A12" => "Relation of Economics to Other Disciplines",
			"A13" => "Relation of Economics to Social Values",
			"A14" => "Sociology of Economics",
			"A19" => "Other"
		);
		$temp["&nbsp;&nbsp;Economic Education and Teaching of Economics"] = array(
			"A20" => "General",
			"A21" => "Pre-college",
			"A22" => "Undergraduate",
			"A23" => "Graduate",
			"A29" => "Other"
		);
		$temp["&nbsp;&nbsp;Collective Works"] = array(
			"A30" => "General",
			"A31" => "Collected Writings of Individuals",
			"A32" => "Collective Volumes",
			"A33" => "Handbooks",
			"A39" => "Other"
		);
		$temp["B History of Economic Thought, Methodology, and Heterodox Approaches"] = array(
			"B00" => "General"
		);
		$temp["&nbsp;&nbsp;History of Economic Thought through 1925"] = array(
			"B10" => "General",
			"B11" => "Preclassical (Ancient, Medieval, Mercantilist, Physiocratic)",
			"B12" => "Classical (includes Adam Smith)",
			"B13" => "Neoclassical through 1925 (Austrian, Marshallian, Walrasian, Stockholm School)",
			"B14" => "Socialist &bull; Marxist",
			"B15" => "Historical &bull; Institutional &bull; Evolutionary",
			"B16" => "Quantitative and Mathematical",
			"B19" => "Other"
		);
		$temp["&nbsp;&nbsp;History of Economic Thought since 1925"] = array(
			"B20" => "General",
			"B21" => "Microeconomics",
			"B22" => "Macroeconomics",
			"B23" => "Econometrics &bull; Quantitative and Mathematical Studies",
			"B24" => "Socialist &bull; Marxist &bull; Sraffian",
			"B25" => "Historical &bull; Institutional &bull; Evolutionary &bull; Austrian",
			"B26" => "Financial Economics",
			"B29" => "Other"
		);
		$temp["&nbsp;&nbsp;History of Economic Thought: Individuals"] = array(
			"B30" => "General",
			"B31" => "Individuals",
			"B32" => "Obituaries"
		);
		$temp["&nbsp;&nbsp;Economic Methodology"] = array(
			"B40" => "General",
			"B41" => "Economic Methodology",
			"B49" => "Other"
		);
		$temp["&nbsp;&nbsp;Current Heterodox Approaches"] = array(
			"B50" => "General",
			"B51" => "Socialist &bull; Marxian &bull; Sraffian",
			"B52" => "Institutional &bull; Evolutionary",
			"B53" => "Austrian",
			"B54" => "Feminist Economics",
			"B59" => "Other"
		);
		$temp["C Mathematical and Quantitative Methods"] = array(
			"C00" => "General",
			"C01" => "Econometrics",
			"C02" => "Mathematical Methods"
		);
		$temp["&nbsp;&nbsp;Econometric and Statistical Methods and Methodology: General"] = array(
			"C10" => "General",
			"C11" => "Bayesian Analysis: General",
			"C12" => "Hypothesis Testing: General",
			"C13" => "Estimation: General",
			"C14" => "Semiparametric and Nonparametric Methods: General",
			"C15" => "Statistical Simulation Methods: General",
			"C18" => "Methodological Issues: General",
			"C19" => "Other"
		);
		$temp["&nbsp;&nbsp;Single Equation Models / Single Variables"] = array(
			"C20" => "General",
			"C21" => "Cross-Sectional Models / Spatial Models / Treatment Effect Models / Quantile Regressions",
			"C22" => "Time-Series Models / Dynamic Quantile Regressions / Dynamic Treatment Effect Models / Diffusion Processes",
			"C23" => "Panel Data Models / Spatio-temporal Models",
			"C24" => "Truncated and Censored Models / Switching Regression Models / Threshold Regression Models",
			"C25" => "Discrete Regression and Qualitative Choice Models / Discrete Regressors / Proportions / Probabilities",
			"C26" => "Instrumental Variables (IV) Estimation",
			"C29" => "Other"
		);
		$temp["&nbsp;&nbsp;Multiple or Simultaneous Equation Models / Multiple Variables"] = array(
			"C30" => "General",
			"C31" => "Cross-Sectional Models / Spatial Models / Treatment Effect Models / Quantile Regressions / Social Interaction Models",
			"C32" => "Time-Series Models / Dynamic Quantile Regressions / Dynamic Treatment Effect Models / Diffusion Processes / State Space Models",
			"C33" => "Panel Data Models / Spatio-temporal Models",
			"C34" => "Truncated and Censored Models / Switching Regression Models",
			"C35" => "Discrete Regression and Qualitative Choice Models / Discrete Regressors / Proportions",
			"C36" => "Instrumental Variables (IV) Estimation",
			"C38" => "Classification Methods / Cluster Analysis / Principal Components / Factor Models",
			"C39" => "Other"
		);
		$temp["&nbsp;&nbsp;Econometric and Statistical Methods: Special Topics"] = array(
			"C40" => "General",
			"C41" => "Duration Analysis / Optimal Timing Strategies",
			"C43" => "Index Numbers and Aggregation",
			"C44" => "Operations Research / Statistical Decision Theory ",
			"C45" => "Neural Networks and Related Topics",
			"C46" => "Specific Distributions / Specific Statistics",
			"C49" => "Other"
		);
		$temp["&nbsp;&nbsp;Econometric Modeling"] = array(
			"C50" => "General",
			"C51" => "Model Construction and Estimation",
			"C52" => "Model Evaluation, Validation, and Selection",
			"C53" => "Forecasting and Prediction Methods / Simulation Methods",
			"C54" => "Quantitative Policy Modeling",
			"C55" => "Large Data Sets: Modeling and Analysis",
			"C57" => "Econometrics of Games and Auctions",
			"C58" => "Financial Econometrics",
			"C59" => "Other"
		);
		$temp["&nbsp;&nbsp;Mathematical Methods / Programming Models / Mathematical and Simulation Modeling"] = array(
			"C60" => "General",
			"C61" => "Optimization Techniques / Programming Models / Dynamic Analysis",
			"C62" => "Existence and Stability Conditions of Equilibrium",
			"C63" => "Computational Techniques / Simulation Modeling",
			"C65" => "Miscellaneous Mathematical Tools",
			"C67" => "Input-Output Models",
			"C68" => "Computable General Equilibrium Models",
			"C69" => "Other"
		);
		$temp["&nbsp;&nbsp;Game Theory and Bargaining Theory"] = array(
			"C70" => "General",
			"C71" => "Cooperative Games",
			"C72" => "Noncooperative Games",
			"C73" => "Stochastic and Dynamic Games / Evolutionary Games / Repeated Games",
			"C78" => "Bargaining Theory / Matching Theory",
			"C79" => "Other"
		);
		$temp["&nbsp;&nbsp;Data Collection and Data Estimation Methodology / Computer Programs"] = array(
			"C80" => "General",
			"C81" => "Methodology for Collecting, Estimating, and Organizing Microeconomic Data / Data Access",
			"C82" => "Methodology for Collecting, Estimating, and Organizing Macroeconomic Data / Data Access",
			"C83" => "Survey Methods / Sampling Methods",
			"C87" => "Econometric Software",
			"C88" => "Other Computer Software",
			"C89" => "Other"
		);
		$temp["&nbsp;&nbsp;Design of Experiments"] = array(
			"C90" => "General",
			"C91" => "Laboratory, Individual Behavior",
			"C92" => "Laboratory, Group Behavior",
			"C93" => "Field Experiments",
			"C99" => "Other"
		);
		$temp["D Microeconomics"] = array(
			"D00" => "General",
			"D01" => "Microeconomic Behavior: Underlying Principles",
			"D02" => "Institutions: Design, Formation, Operations, and Impact",
			"D03" => "Behavioral Microeconomics: Underlying Principles",
			"D04" => "Microeconomic Policy: Formulation, Implementation, and Evaluation"
		);
		$temp["&nbsp;&nbsp;Household Behavior and Family Economics"] = array(
			"D10" => "General",
			"D11" => "Consumer Economics: Theory",
			"D12" => "Consumer Economics: Empirical Analysis",
			"D13" => "Household Production and Intrahousehold Allocation",
			"D14" => "Household Saving; Personal Finance",
			"D18" => "Consumer Protection",
			"D19" => "Other"
		);
		$temp["&nbsp;&nbsp;Production and Organizations"] = array(
			"D20" => "General",
			"D21" => "Firm Behavior: Theory",
			"D22" => "Firm Behavior: Empirical Analysis",
			"D23" => "Organizational Behavior / Transaction Costs / Property Rights",
			"D24" => "Production / Cost / Capital / Capital, Total Factor, and Multifactor Productivity / Capacity",
			"D29" => "Other"
		);
		$temp["&nbsp;&nbsp;Distribution"] = array(
			"D30" => "General",
			"D31" => "Personal Income, Wealth, and Their Distributions",
			"D33" => "Factor Income Distribution",
			"D39" => "Other"
		);
		$temp["&nbsp;&nbsp;Market Structure, Pricing, and Design"] = array(
			"D40" => "General",
			"D41" => "Perfect Competition",
			"D42" => "Monopoly",
			"D43" => "Oligopoly and Other Forms of Market Imperfection",
			"D44" => "Auctions",
			"D45" => "Rationing / Licensing",
			"D46" => "Value Theory",
			"D47" => "Market Design",
			"D49" => "Other"
		);
		$temp["&nbsp;&nbsp;General Equilibrium and Disequilibrium"] = array(
			"D50" => "General",
			"D51" => "Exchange and Production Economies",
			"D52" => "Incomplete Markets",
			"D53" => "Financial Markets",
			"D57" => "Input-Output Tables and Analysis",
			"D58" => "Computable and Other Applied General Equilibrium Models",
			"D59" => "Other"
		);
		$temp["&nbsp;&nbsp;Welfare Economics"] = array(
			"D60" => "General",
			"D61" => "Allocative Efficiency / Cost-Benefit Analysis",
			"D62" => "Externalities",
			"D63" => "Equity, Justice, Inequality, and Other Normative Criteria and Measurement",
			"D64" => "Altruism / Philanthropy / Intergenerational Transfers",
			"D69" => "Other"
		);
		$temp["&nbsp;&nbsp;Analysis of Collective Decision-Making"] = array(
			"D70" => "General",
			"D71" => "Social Choice / Clubs / Committees / Associations",
			"D72" => "Political Processes: Rent-Seeking, Lobbying, Elections, Legislatures, and Voting Behavior",
			"D73" => "Bureaucracy / Administrative Processes in Public Organizations / Corruption",
			"D74" => "Conflict / Conflict Resolution / Alliances / Revolutions",
			"D78" => "Positive Analysis of Policy Formulation and Implementation",
			"D79" => "Other"
		);
		$temp["&nbsp;&nbsp;Information, Knowledge, and Uncertainty"] = array(
			"D80" => "General",
			"D81" => "Criteria for Decision-Making under Risk and Uncertainty",
			"D82" => "Asymmetric and Private Information / Mechanism Design",
			"D83" => "Search / Learning / Information and Knowledge / Communication / Belief / Unawareness",
			"D84" => "Expectations / Speculations",
			"D85" => "Network Formation and Analysis: Theory",
			"D86" => "Economics of Contract: Theory",
			"D87" => "Neuroeconomics",
			"D89" => "Other"
		);
		$temp["&nbsp;&nbsp;Intertemporal Choice"] = array(
			"D90" => "General",
			"D91" => "Intertemporal Household Choice / Life Cycle Models and Saving",
			"D92" => "Intertemporal Firm Choice, Investment, Capacity, and Financing",
			"D99" => "Other"
		);
		$temp["E Macroeconomics and Monetary Economics"] = array(
			"E00" => "General",
			"E01" => "Measurement and Data on National Income and Product Accounts and Wealth / Environmental Accounts",
			"E02" => "Institutions and the Macroeconomy",
			"E03" => "Behavioral Macroeconomics"
		);
		$temp["&nbsp;&nbsp;General Aggregative Models"] = array(
			"E10" => "General",
			"E11" => "Marxian / Sraffian / Kaleckian",
			"E12" => "Keynes / Keynesian / Post-Keynesian",
			"E14" => "Austrian / Evolutionary / Institutional ",
			"E13" => "Neoclassical",
			"E16" => "Social Accounting Matrix",
			"E17" => "Forecasting and Simulation: Models and Applications",
			"E19" => "Other"
		);
		$temp["&nbsp;&nbsp;Consumption, Saving, Production, Investment, Labor Markets, and Informal Economy"] = array(
			"E20" => "General",
			"E21" => "Consumption / Saving / Wealth",
			"E22" => "Investment / Capital / Intangible Capital / Capacity",
			"E23" => "Production",
			"E24" => "Employment / Unemployment / Wages / Intergenerational Income Distribution / Aggregate Human Capital / Aggregate Labor Productivity",
			"E25" => "Aggregate Factor Income Distribution",
			"E26" => "Informal Economy / Underground Economy",
			"E27" => "Forecasting and Simulation: Models and Applications",
			"E29" => "Other"
		);
		$temp["&nbsp;&nbsp;Prices, Business Fluctuations, and Cycles"] = array(
			"E30" => "General",
			"E31" => "Price Level / Inflation / Deflation",
			"E32" => "Business Fluctuations / Cycles",
			"E37" => "Forecasting and Simulation: Models and Applications",
			"E39" => "Other"
		);
		$temp["&nbsp;&nbsp;Money and Interest Rates"] = array(
			"E40" => "General",
			"E41" => "Demand for Money",
			"E42" => "Monetary Systems / Standards / Regimes / Government and the Monetary System / Payment Systems",
			"E43" => "Interest Rates: Determination, Term Structure, and Effects ",
			"E44" => "Financial Markets and the Macroeconomy",
			"E47" => "Forecasting and Simulation: Models and Applications",
			"E49" => "Other"
		);
		$temp["&nbsp;&nbsp;Monetary Policy, Central Banking, and the Supply of Money and Credit"] = array(
			"E50" => "General",
			"E51" => "Money Supply / Credit / Money Multipliers",
			"E52" => "Monetary Policy",
			"E58" => "Central Banks and Their Policies",
			"E59" => "Other"
		);
		$temp["&nbsp;&nbsp;Macroeconomic Policy, Macroeconomic Aspects of Public Finance, and General Outlook"] = array(
			"E60" => "General",
			"E61" => "Policy  Objectives / Policy Designs and Consistency / Policy Coordination",
			"E62" => "Fiscal Policy",
			"E63" => "Comparative or Joint Analysis of Fiscal and Monetary Policy / Stabilization / Treasury Policy",
			"E64" => "Incomes Policy / Price Policy",
			"E65" => "Studies of Particular Policy Episodes",
			"E66" => "General Outlook and Conditions",
			"E69" => "Other"
		);
		$temp["F International Economics"] = array(
			"F00" => "General",
			"F01" => "Global Outlook",
			"F02" => "International Economic Order and Integration"
		);
		$temp["&nbsp;&nbsp;Trade"] = array(
			"F10" => "General",
			"F11" => "Neoclassical Models of Trade",
			"F12" => "Models of Trade with Imperfect Competition and Scale Economies / Fragmentation",
			"F13" => "Trade Policy / International Trade Organizations",
			"F14" => "Empirical Studies of Trade",
			"F15" => "Economic Integration",
			"F16" => "Trade and Labor Market Interactions",
			"F17" => "Trade Forecasting and Simulation",
			"F18" => "Trade and Environment",
			"F19" => "Other"
		);
		$temp["&nbsp;&nbsp;International Factor Movements and International Business"] = array(
			"F20" => "General",
			"F21" => "International Investment / Long-Term Capital Movements",
			"F22" => "International Migration",
			"F23" => "Multinational Firms / International Business",
			"F24" => "Remittances",
			"F29" => "Other"
		);
		$temp["&nbsp;&nbsp;International Finance"] = array(
			"F30" => "General",
			"F31" => "Foreign Exchange",
			"F32" => "Current Account Adjustment / Short-Term Capital Movements",
			"F33" => "International Monetary Arrangements and Institutions",
			"F34" => "International Lending and Debt Problems",
			"F35" => "Foreign Aid",
			"F36" => "Financial Aspects of Economic Integration",
			"F37" => "International Finance Forecasting and Simulation: Models and Applications",
			"F38" => "International Financial Policy: Financial Transactions Tax; Capital Controls",
			"F39" => "Other"
		);
		$temp["&nbsp;&nbsp;Macroeconomic Aspects of International Trade and Finance"] = array(
			"F40" => "General",
			"F41" => "Open Economy Macroeconomics",
			"F42" => "International Policy Coordination and Transmission",
			"F43" => "Economic Growth of Open Economies",
			"F44" => "International Business Cycles",
			"F45" => "Macroeconomic Issues of Monetary Unions",
			"F47" => "Forecasting and Simulation: Models and Applications",
			"F49" => "Other"
		);
		$temp["&nbsp;&nbsp;International Relations, National Security, and International Political Economy"] = array(
			"F50" => "General",
			"F51" => "International Conflicts / Negotiations / Sanctions",
			"F52" => "National Security / Economic Nationalism",
			"F53" => "International Agreements and Observance / International Organizations",
			"F54" => "Colonialism / Imperialism / Postcolonialism",
			"F55" => "International Institutional Arrangements",
			"F59" => "Other"
		);
		$temp["&nbsp;&nbsp;Economic Impacts of Globalization"] = array(
			"F60" => "General",
			"F61" => "Microeconomic Impacts",
			"F62" => "Macroeconomic Impacts",
			"F63" => "Economic Development",
			"F64" => "Environment",
			"F65" => "Finance",
			"F66" => "Labor",
			"F68" => "Policy",
			"F69" => "Other"
		);
		$temp["G Financial Economics"] = array(
			"G00" => "General",
			"G01" => "Financial Crises",
			"G02" => "Behavioral Finance: Underlying Principles"
		);
		$temp["&nbsp;&nbsp;General Financial Markets"] = array(
			"G10" => "General",
			"G11" => "Portfolio Choice / Investment Decisions",
			"G12" => "Asset Pricing / Trading Volume / Bond Interest Rates",
			"G13" => "Contingent Pricing / Futures Pricing",
			"G14" => "Information and Market Efficiency / Event Studies / Insider Trading",
			"G15" => "International Financial Markets",
			"G17" => "Financial Forecasting and Simulation",
			"G18" => "Government Policy and Regulation",
			"G19" => "Other"
		);
		$temp["&nbsp;&nbsp;Financial Institutions and Services"] = array(
			"G20" => "General",
			"G21" => "Banks / Depository Institutions / Micro Finance Institutions / Mortgages",
			"G22" => "Insurance / Insurance Companies / Actuarial Studies",
			"G23" => "Non-bank Financial Institutions / Financial Instruments / Institutional Investors",
			"G24" => "Investment Banking / Venture Capital / Brokerage / Ratings and Ratings Agencies",
			"G28" => "Government Policy and Regulation",
			"G29" => "Other"
		);
		$temp["&nbsp;&nbsp;Corporate Finance and Governance"] = array(
			"G30" => "General",
			"G31" => "Capital Budgeting / Fixed Investment and Inventory Studies / Capacity",
			"G32" => "Financing Policy / Financial Risk and Risk Management / Capital and Ownership Structure / Value of Firms / Goodwill",
			"G33" => "Bankruptcy / Liquidation",
			"G34" => "Mergers / Acquisitions / Restructuring / Corporate Governance",
			"G35" => "Payout Policy",
			"G38" => "Government Policy and Regulation",
			"G39" => "Other"
		);
		$temp["H Public Economics"] = array(
			"H00" => "General"
		);
		$temp["&nbsp;&nbsp;Structure and Scope of Government"] = array(
			"H10" => "General",
			"H11" => "Structure, Scope, and Performance of Government",
			"H12" => "Crisis Management",
			"H13" => "Economics of Eminent Domain / Expropriation / Nationalization",
			"H19" => "Other"
		);
		$temp["&nbsp;&nbsp;Taxation, Subsidies, and Revenue"] = array(
			"H20" => "General",
			"H21" => "Efficiency / Optimal Taxation",
			"H22" => "Incidence",
			"H23" => "Externalities / Redistributive Effects / Environmental Taxes and Subsidies",
			"H24" => "Personal Income and Other Nonbusiness Taxes and Subsidies",
			"H25" => "Business Taxes and Subsidies",
			"H26" => "Tax Evasion and Avoidance",
			"H27" => "Other Sources of Revenue",
			"H29" => "Other"
		);
		$temp["&nbsp;&nbsp;Fiscal Policies and Behavior of Economic Agents"] = array(
			"H30" => "General",
			"H31" => "Household",
			"H32" => "Firm",
			"H39" => "Other"
		);
		$temp["&nbsp;&nbsp;Publicly Provided Goods"] = array(
			"H40" => "General",
			"H41" => "Public Goods",
			"H42" => "Publicly Provided Private Goods",
			"H43" => "Project Evaluation / Social Discount Rate",
			"H44" => "Publicly Provided Goods: Mixed Markets",
			"H49" => "Other"
		);
		$temp["&nbsp;&nbsp;National Government Expenditures and Related Policies"] = array(
			"H50" => "General",
			"H51" => "Government Expenditures and Health",
			"H52" => "Government Expenditures and Education",
			"H53" => "Government Expenditures and Welfare Programs",
			"H54" => "Infrastructures / Other Public Investment and Capital Stock",
			"H55" => "Social Security and Public Pensions",
			"H56" => "National Security and War",
			"H57" => "Procurement",
			"H59" => "Other"
		);
		$temp["&nbsp;&nbsp;National Budget, Deficit, and Debt"] = array(
			"H60" => "General",
			"H61" => "Budget / Budget Systems",
			"H62" => "Deficit / Surplus",
			"H63" => "Debt / Debt Management / Sovereign Debt",
			"H68" => "Forecasts of Budgets, Deficits, and Debt",
			"H69" => "Other"
		);
		$temp["&nbsp;&nbsp;State and Local Government / Intergovernmental Relations"] = array(
			"H70" => "General",
			"H71" => "State and Local Taxation, Subsidies, and Revenue",
			"H72" => "State and Local Budget and Expenditures",
			"H73" => "Interjurisdictional Differentials and Their Effects",
			"H74" => "State and Local Borrowing",
			"H75" => "State and Local Government: Health / Education / Welfare / Public Pensions",
			"H76" => "State and Local Government: Other Expenditure Categories",
			"H77" => "Intergovernmental Relations / Federalism / Secession",
			"H79" => "Other"
		);
		$temp["&nbsp;&nbsp;Miscellaneous Issues"] = array(
			"H80" => "General",
			"H81" => "Governmental Loans / Loan Guarantees / Credits / Grants / Bailouts",
			"H82" => "Governmental Property",
			"H83" => "Public Administration / Public Sector Accounting and Audits",
			"H84" => "Disaster Aid",
			"H87" => "International Fiscal Issues / International Public Goods",
			"H89" => "Other"
		);
		$temp["I Health, Education, and Welfare"] = array(
			"I00" => "General"
		);
		$temp["&nbsp;&nbsp;Health"] = array(
			"I10" => "General",
			"I11" => "Analysis of Health Care Markets",
			"I12" => "Health Behavior",
			"I13" => "Health Insurance, Public and Private",
			"I14" => "Health and Inequality",
			"I15" => "Health and Economic Development",
			"I18" => "Government Policy / Regulation / Public Health",
			"I19" => "Other"
		);
		$temp["&nbsp;&nbsp;Education and Research Institutions"] = array(
			"I20" => "General",
			"I21" => "Analysis of Education",
			"I22" => "Educational Finance / Financial Aid",
			"I23" => "Higher Education / Research Institutions",
			"I24" => "Education and Inequality",
			"I25" => "Education and Economic Development",
			"I26" => "Returns to Education",
			"I28" => "Government Policy",
			"I29" => "Other"
		);
		$temp["&nbsp;&nbsp;Welfare, Well-Being, and Poverty"] = array(
			"I30" => "General",
			"I31" => "General Welfare, Well-Being  ",
			"I32" => "Measurement and Analysis of Poverty",
			"I38" => "Government Policy / Provision and Effects of Welfare Programs",
			"I39" => "Other"
		);
		$temp["J Labor and Demographic Economics"] = array(
			"J00" => "General",
			"J01" => "Labor Economics: General",
			"J08" => "Labor Economics Policies"
		);
		$temp["&nbsp;&nbsp;Demographic Economics"] = array(
			"J10" => "General",
			"J11" => "Demographic Trends, Macroeconomic Effects, and Forecasts",
			"J12" => "Marriage / Marital Dissolution / Family Structure / Domestic Abuse",
			"J13" => "Fertility / Family Planning / Child Care / Children / Youth",
			"J14" => "Economics of the Elderly / Economics of the Handicapped / Non-Labor Market Discrimination",
			"J15" => "Economics of Minorities, Races, Indigenous Peoples, and Immigrants / Non-labor Discrimination",
			"J16" => "Economics of Gender / Non-labor Discrimination",
			"J17" => "Value of Life / Forgone Income",
			"J18" => "Public Policy",
			"J19" => "Other"
		);
		$temp["&nbsp;&nbsp;Demand and Supply of Labor"] = array(
			"J20" => "General",
			"J21" => "Labor Force and Employment, Size, and Structure",
			"J22" => "Time Allocation and Labor Supply",
			"J23" => "Labor Demand",
			"J24" => "Human Capital / Skills / Occupational Choice / Labor Productivity",
			"J26" => "Retirement / Retirement Policies",
			"J28" => "Safety / Job Satisfaction / Related Public Policy",
			"J29" => "Other"
		);
		$temp["&nbsp;&nbsp;Wages, Compensation, and Labor Costs"] = array(
			"J30" => "General",
			"J31" => "Wage Level and Structure / Wage Differentials",
			"J32" => "Nonwage Labor Costs and Benefits / Retirement Plans / Private Pensions",
			"J33" => "Compensation Packages / Payment Methods",
			"J38" => "Public Policy",
			"J39" => "Other"
		);
		$temp["&nbsp;&nbsp;Particular Labor Markets"] = array(
			"J40" => "General",
			"J41" => "Labor Contracts",
			"J42" => "Monopsony / Segmented Labor Markets",
			"J43" => "Agricultural Labor Markets",
			"J44" => "Professional Labor Markets / Occupational Licensing",
			"J45" => "Public Sector Labor Markets",
			"J46" => "Informal Labor Markets",
			"J47" => "Coercive Labor Markets",
			"J48" => "Public Policy",
			"J49" => "Other"
		);
		$temp["&nbsp;&nbsp;Labor-Management Relations, Trade Unions, and Collective Bargaining"] = array(
			"J50" => "General",
			"J51" => "Trade Unions: Objectives, Structure, and Effects",
			"J52" => "Dispute Resolution:  Strikes, Arbitration, and Mediation / Collective Bargaining",
			"J53" => "Labor-Management Relations / Industrial Jurisprudence",
			"J54" => "Producer Cooperatives / Labor Managed Firms / Employee Ownership",
			"J58" => "Public Policy",
			"J59" => "Other"
		);
		$temp["&nbsp;&nbsp;Mobility, Unemployment, Vacancies, and Immigrant Workers"] = array(
			"J60" => "General",
			"J61" => "Geographic Labor Mobility / Immigrant Workers",
			"J62" => "Job, Occupational, and Intergenerational Mobility",
			"J63" => "Turnover / Vacancies / Layoffs",
			"J64" => "Unemployment: Models, Duration, Incidence, and Job Search",
			"J65" => "Unemployment Insurance / Severance Pay / Plant Closings",
			"J68" => "Public Policy",
			"J69" => "Other"
		);
		$temp["&nbsp;&nbsp;Labor Discrimination"] = array(
			"J70" => "General",
			"J71" => "Discrimination",
			"J78" => "Public Policy",
			"J79" => "Other"
		);
		$temp["&nbsp;&nbsp;Labor Standards: National and International"] = array(
			"J80" => "General",
			"J81" => "Working Conditions",
			"J82" => "Labor Force Composition",
			"J83" => "Workers' Rights",
			"J88" => "Public Policy",
			"J89" => "Other"
		);
		$temp["K Law and Economics"] = array(
			"K00" => "General"
		);
		$temp["&nbsp;&nbsp;Basic Areas of Law"] = array(
			"K10" => "General",
			"K11" => "Property Law",
			"K12" => "Contract Law",
			"K13" => "Tort Law and Product Liability / Forensic Economics",
			"K14" => "Criminal Law",
			"K19" => "Other"
		);
		$temp["&nbsp;&nbsp;Regulation and Business Law"] = array(
			"K20" => "General",
			"K21" => "Antitrust Law",
			"K22" => "Business and Securities Law",
			"K23" => "Regulated Industries and Administrative Law",
			"K29" => "Other"
		);
		$temp["&nbsp;&nbsp;Other Substantive Areas of Law"] = array(
			"K30" => "General",
			"K31" => "Labor Law",
			"K32" => "Environmental, Health, and Safety Law",
			"K33" => "International Law",
			"K34" => "Tax Law",
			"K35" => "Personal Bankruptcy Law",
			"K36" => "Family and Personal Law",
			"K37" => "Immigration Law",
			"K39" => "Other"
		);
		$temp["&nbsp;&nbsp;Legal Procedure, the Legal System, and Illegal Behavior"] = array(
			"K40" => "General",
			"K41" => "Litigation Process",
			"K42" => "Illegal Behavior and the Enforcement of Law",
			"K49" => "Other"
		);
		$temp["L Industrial Organization"] = array(
			"L00" => "General"
		);
		$temp["&nbsp;&nbsp;Market Structure, Firm Strategy, and Market Performance"] = array(
			"L10" => "General",
			"L11" => "Production, Pricing, and Market Structure / Size Distribution of Firms",
			"L12" => "Monopoly / Monopolization Strategies",
			"L13" => "Oligopoly and Other Imperfect Markets",
			"L14" => "Transactional Relationships / Contracts and Reputation / Networks",
			"L15" => "Information and Product Quality / Standardization and Compatibility",
			"L16" => "Industrial Organization and Macroeconomics: Industrial Structure and Structural Change / Industrial Price Indices",
			"L17" => "Open Source Products and Markets",
			"L19" => "Other"
		);
		$temp["&nbsp;&nbsp;Firm Objectives, Organization, and Behavior"] = array(
			"L20" => "General",
			"L21" => "Business Objectives of the Firm",
			"L22" => "Firm Organization and Market Structure",
			"L23" => "Organization of Production",
			"L24" => "Contracting Out / Joint Ventures / Technology Licensing",
			"L25" => "Firm Performance: Size, Diversification, and Scope",
			"L26" => "Entrepreneurship",
			"L29" => "Other"
		);
		$temp["&nbsp;&nbsp;Nonprofit Organizations and Public Enterprise"] = array(
			"L30" => "General",
			"L31" => "Nonprofit Institutions / NGOs / Social Entrepreneurship",
			"L32" => "Public Enterprises / Public-Private Enterprises",
			"L33" => "Comparison of Public and Private Enterprises and Nonprofit Institutions / Privatization / Contracting Out",
			"L38" => "Public Policy",
			"L39" => "Other"
		);
		$temp["&nbsp;&nbsp;Antitrust Issues and Policies"] = array(
			"L40" => "General",
			"L41" => "Monopolization / Horizontal Anticompetitive Practices",
			"L42" => "Vertical Restraints / Resale Price Maintenance / Quantity Discounts",
			"L43" => "Legal Monopolies and Regulation or Deregulation",
			"L44" => "Antitrust Policy and Public Enterprises, Nonprofit Institutions, and Professional Organizations",
			"L49" => "Other"
		);
		$temp["&nbsp;&nbsp;Regulation and Industrial Policy"] = array(
			"L50" => "General",
			"L51" => "Economics of Regulation",
			"L52" => "Industrial Policy / Sectoral Planning Methods",
			"L53" => "Enterprise Policy ",
			"L59" => "Other"
		);
		$temp["&nbsp;&nbsp;Industry Studies: Manufacturing"] = array(
			"L60" => "General",
			"L61" => "Metals and Metal Products / Cement / Glass / Ceramics",
			"L62" => "Automobiles / Other Transportation Equipment / Related Parts and Equipment",
			"L63" => "Microelectronics / Computers / Communications Equipment",
			"L64" => "Other Machinery / Business Equipment / Armaments",
			"L65" => "Chemicals / Rubber / Drugs / Biotechnology",
			"L66" => "Food / Beverages / Cosmetics / Tobacco / Wine and Spirits",
			"L67" => "Other Consumer Nondurables: Clothing, Textiles, Shoes, and Leather Goods; Household Goods; Sports Equipment",
			"L68" => "Appliances / Furniture / Other Consumer Durables",
			"L69" => "Other"
		);
		$temp["&nbsp;&nbsp;Industry Studies: Primary Products and Construction"] = array(
			"L70" => "General",
			"L71" => "Mining, Extraction, and Refining: Hydrocarbon Fuels",
			"L72" => "Mining, Extraction, and Refining: Other Nonrenewable Resources",
			"L73" => "Forest Products",
			"L74" => "Construction",
			"L78" => "Government Policy",
			"L79" => "Other"
		);
		$temp["&nbsp;&nbsp;Industry Studies: Services"] = array(
			"L80" => "General",
			"L81" => "Retail and Wholesale Trade / e-Commerce",
			"L82" => "Entertainment / Media",
			"L83" => "Sports / Gambling / Restaurants / Recreation / Tourism",
			"L84" => "Personal, Professional, and Business Services",
			"L85" => "Real Estate Services",
			"L86" => "Information and Internet Services / Computer Software",
			"L87" => "Postal and Delivery Services",
			"L88" => "Government Policy",
			"L89" => "Other"
		);
		$temp["&nbsp;&nbsp;Industry Studies: Transportation and Utilities"] = array(
			"L90" => "General",
			"L91" => "Transportation: General",
			"L92" => "Railroads and Other Surface Transportation",
			"L93" => "Air Transportation",
			"L94" => "Electric Utilities",
			"L95" => "Gas Utilities / Pipelines / Water Utilities",
			"L96" => "Telecommunications",
			"L97" => "Utilities: General",
			"L98" => "Government Policy",
			"L99" => "Other"
		);
		$temp["M Business Administration and Business Economics / Marketing / Accounting / Personnel Economics"] = array(
			"M00" => "General"
		);
		$temp["&nbsp;&nbsp;Business Administration"] = array(
			"M10" => "General",
			"M11" => "Production Management",
			"M12" => "Personnel Management / Executives; Executive Compensation",
			"M13" => "New Firms / Startups",
			"M14" => "Corporate Culture / Diversity / Social Responsibility",
			"M15" => "IT Management",
			"M16" => "International Business Administration",
			"M19" => "Other"
		);
		$temp["&nbsp;&nbsp;Business Economics"] = array(
			"M20" => "General",
			"M21" => "Business Economics",
			"M29" => "Other"
		);
		$temp["&nbsp;&nbsp;Marketing and Advertising"] = array(
			"M30" => "General",
			"M31" => "Marketing",
			"M37" => "Advertising",
			"M38" => "Government Policy and Regulation",
			"M39" => "Other"
		);
		$temp["&nbsp;&nbsp;Accounting and Auditing"] = array(
			"M40" => "General",
			"M41" => "Accounting",
			"M42" => "Auditing",
			"M48" => "Government Policy and Regulation",
			"M49" => "Other"
		);
		$temp["&nbsp;&nbsp;Personnel Economics"] = array(
			"M50" => "General",
			"M51" => "Firm Employment Decisions / Promotions",
			"M52" => "Compensation and Compensation Methods and Their Effects",
			"M53" => "Training",
			"M54" => "Labor Management",
			"M55" => "Labor Contracting Devices",
			"M59" => "Other"
		);
		$temp["N Economic History"] = array(
			"N00" => "General",
			"N01" => "Development of the Discipline: Historiographical; Sources and Methods"
		);
		$temp["&nbsp;&nbsp;Macroeconomics and Monetary Economics / Industrial Structure / Growth / Fluctuations"] = array(
			"N10" => "General, International, or Comparative",
			"N11" => "U.S. / Canada: Pre-1913",
			"N12" => "U.S. / Canada: 1913-",
			"N13" => "Europe: Pre-1913",
			"N14" => "Europe: 1913-",
			"N15" => "Asia including Middle East",
			"N16" => "Latin America / Caribbean",
			"N17" => "Africa / Oceania"
		);
		$temp["&nbsp;&nbsp;Financial Markets and Institutions"] = array(
			"N20" => "General, International, or Comparative",
			"N21" => "U.S. / Canada: Pre-1913",
			"N22" => "U.S. / Canada: 1913-",
			"N23" => "Europe: Pre-1913",
			"N24" => "Europe: 1913-",
			"N25" => "Asia including Middle East",
			"N26" => "Latin America / Caribbean",
			"N27" => "Africa / Oceania"
		);
		$temp["&nbsp;&nbsp;Labor and Consumers, Demography, Education, Health, Welfare, Income, Wealth, Religion, and Philanthropy"] = array(
			"N30" => "General, International, or Comparative",
			"N31" => "U.S. / Canada: Pre-1913",
			"N32" => "U.S. / Canada: 1913-",
			"N33" => "Europe: Pre-1913",
			"N34" => "Europe: 1913-",
			"N35" => "Asia including Middle East",
			"N36" => "Latin America / Caribbean",
			"N37" => "Africa / Oceania"
		);
		$temp["&nbsp;&nbsp;Government, War, Law, International Relations, and Regulation"] = array(
			"N40" => "General, International, or Comparative",
			"N41" => "U.S. / Canada: Pre-1913",
			"N42" => "U.S. / Canada: 1913-",
			"N43" => "Europe: Pre-1913",
			"N44" => "Europe: 1913-",
			"N45" => "Asia including Middle East",
			"N46" => "Latin America / Caribbean",
			"N47" => "Africa / Oceania"
		);
		$temp["&nbsp;&nbsp;Agriculture, Natural Resources, Environment, and Extractive Industries"] = array(
			"N50" => "General, International, or Comparative",
			"N51" => "U.S. / Canada: Pre-1913",
			"N52" => "U.S. / Canada: 1913-",
			"N53" => "Europe: Pre-1913",
			"N54" => "Europe: 1913-",
			"N55" => "Asia including Middle East",
			"N56" => "Latin America / Caribbean",
			"N57" => "Africa / Oceania"
		);
		$temp["&nbsp;&nbsp;Manufacturing and Construction"] = array(
			"N60" => "General, International, or Comparative",
			"N61" => "U.S. / Canada: Pre-1913",
			"N62" => "U.S. / Canada: 1913-",
			"N63" => "Europe: Pre-1913",
			"N64" => "Europe: 1913-",
			"N65" => "Asia including Middle East",
			"N66" => "Latin America / Caribbean",
			"N67" => "Africa / Oceania"
		);
		$temp["&nbsp;&nbsp;Transport, Trade, Energy, Technology, and Other Services"] = array(
			"N70" => "General, International, or Comparative",
			"N71" => "U.S. / Canada: Pre-1913",
			"N72" => "U.S. / Canada: 1913-",
			"N73" => "Europe: Pre-1913",
			"N74" => "Europe: 1913-",
			"N75" => "Asia including Middle East",
			"N76" => "Latin America / Caribbean",
			"N77" => "Africa / Oceania"
		);
		$temp["&nbsp;&nbsp;Micro-Business History"] = array(
			"N80" => "General, International, or Comparative",
			"N81" => "U.S. / Canada: Pre-1913",
			"N82" => "U.S. / Canada: 1913-",
			"N83" => "Europe: Pre-1913",
			"N84" => "Europe: 1913-",
			"N85" => "Asia including Middle East",
			"N86" => "Latin America / Caribbean",
			"N87" => "Africa / Oceania"
		);
		$temp["&nbsp;&nbsp;Regional and Urban History"] = array(
			"N90" => "General, International, or Comparative",
			"N91" => "U.S. / Canada: Pre-1913",
			"N92" => "U.S. / Canada: 1913-",
			"N93" => "Europe: Pre-1913",
			"N94" => "Europe: 1913-",
			"N95" => "Asia including Middle East",
			"N96" => "Latin America / Caribbean",
			"N97" => "Africa / Oceania"
		);
		$temp["O Economic Development, Innovation, Technological Change, and Growth"] = array();
		$temp["&nbsp;&nbsp;Economic Development"] = array(
			"O10" => "General",
			"O11" => "Macroeconomic Analyses of Economic Development",
			"O12" => "Microeconomic Analyses of Economic Development",
			"O13" => "Agriculture / Natural Resources / Energy / Environment / Other Primary Products",
			"O14" => "Industrialization / Manufacturing and Service Industries / Choice of Technology",
			"O15" => "Human Resources / Human Development / Income Distribution / Migration",
			"O16" => "Financial Markets / Saving and Capital Investment / Corporate Finance and Governance",
			"O17" => "Formal and Informal Sectors / Shadow Economy / Institutional Arrangements",
			"O18" => "Urban, Rural, Regional, and Transportation Analysis / Housing / Infrastructure",
			"O19" => "International Linkages to Development / Role of International Organizations"
		);
		$temp["&nbsp;&nbsp;Development Planning and Policy"] = array(
			"O20" => "General",
			"O21" => "Planning Models / Planning Policy",
			"O22" => "Project Analysis",
			"O23" => "Fiscal and Monetary Policy in Development",
			"O24" => "Trade Policy / Factor Movement Policy / Foreign Exchange Policy",
			"O25" => "Industrial Policy",
			"O29" => "Other"
		);
		$temp["&nbsp;&nbsp;Innovation / Research and Development / Technological Change / Intellectual Property Rights"] = array(
			"O30" => "General",
			"O31" => "Innovation and Invention: Processes and Incentives",
			"O32" => "Management of Technological Innovation and R&D",
			"O33" => "Technological Change: Choices and Consequences / Diffusion Processes",
			"O34" => "Intellectual Property and Intellectual Capital",
			"O35" => "Social Innovation",
			"O38" => "Government Policy",
			"O39" => "Other"
		);
		$temp["&nbsp;&nbsp;Economic Growth and Aggregate Productivity"] = array(
			"O40" => "General",
			"O41" => "One, Two, and Multisector Growth Models",
			"O42" => "Monetary Growth Models",
			"O43" => "Institutions and Growth",
			"O44" => "Environment and Growth",
			"O47" => "Empirical Studies of Economic Growth / Aggregate Productivity / Cross-Country Output Convergence",
			"O49" => "Other"
		);
		$temp["&nbsp;&nbsp;Economywide Country Studies"] = array(
			"O50" => "General",
			"O51" => "U.S. / Canada",
			"O52" => "Europe",
			"O53" => "Asia including Middle East",
			"O54" => "Latin America / Caribbean",
			"O55" => "Africa",
			"O56" => "Oceania",
			"O57" => "Comparative Studies of Countries"
		);
		$temp["P Economic Systems"] = array(
			"P00" => "General"
		);
		$temp["&nbsp;&nbsp;Capitalist Systems"] = array(
			"P10" => "General",
			"P11" => "Planning, Coordination, and Reform",
			"P12" => "Capitalist Enterprises",
			"P13" => "Cooperative Enterprises",
			"P14" => "Property Rights",
			"P16" => "Political Economy",
			"P17" => "Performance and Prospects",
			"P18" => "Energy / Environment",
			"P19" => "Other"
		);
		$temp["&nbsp;&nbsp;Socialist Systems and Transitional Economies"] = array(
			"P20" => "General",
			"P21" => "Planning, Coordination, and Reform",
			"P22" => "Prices",
			"P23" => "Factor and Product Markets / Industry Studies / Population",
			"P24" => "National Income, Product, and Expenditure / Money / Inflation",
			"P25" => "Urban, Rural, and Regional Economics",
			"P26" => "Political Economy / Property Rights",
			"P27" => "Performance and Prospects",
			"P28" => "Natural Resources / Energy / Environment",
			"P29" => "Other"
		);
		$temp["&nbsp;&nbsp;Socialist Institutions and Their Transitions"] = array(
			"P30" => "General",
			"P31" => "Socialist Enterprises and Their Transitions",
			"P32" => "Collectives / Communes / Agriculture",
			"P33" => "International Trade, Finance, Investment, Relations, and Aid",
			"P34" => "Financial Economics",
			"P35" => "Public Economics",
			"P36" => "Consumer Economics / Health / Education and Training / Welfare, Income, Wealth, and Poverty",
			"P37" => "Legal Institutions / Illegal Behavior",
			"P39" => "Other"
		);
		$temp["&nbsp;&nbsp;Other Economic Systems"] = array(
			"P40" => "General",
			"P41" => "Planning, Coordination, and Reform",
			"P42" => "Productive Enterprises / Factor and Product Markets / Prices / Population",
			"P43" => "Public Economics / Financial Economics",
			"P44" => "National Income, Product, and Expenditure / Money / Inflation",
			"P45" => "International Trade, Finance, Investment, and Aid",
			"P46" => "Consumer Economics / Health / Education and Training / Welfare, Income, Wealth, and Poverty",
			"P47" => "Performance and Prospects",
			"P48" => "Political Economy / Legal Institutions / Property Rights / Natural Resources / Energy / Environment / Regional Studies",
			"P49" => "Other"
		);
		$temp["&nbsp;&nbsp;Comparative Economic Systems"] = array(
			"P50" => "General",
			"P51" => "Comparative Analysis of Economic Systems",
			"P52" => "Comparative Studies of Particular Economies",
			"P59" => "Other"
		);
		$temp["Q Agricultural and Natural Resource Economics / Environmental and Ecological Economics"] = array(
			"Q00" => "General",
			"Q01" => "Sustainable Development",
			"Q02" => "Commodity Markets"
		);
		$temp["&nbsp;&nbsp;Agriculture"] = array(
			"Q10" => "General",
			"Q11" => "Aggregate Supply and Demand Analysis / Prices",
			"Q12" => "Micro Analysis of Farm Firms, Farm Households, and Farm Input Markets",
			"Q13" => "Agricultural Markets and Marketing / Cooperatives / Agribusiness",
			"Q14" => "Agricultural Finance",
			"Q15" => "Land Ownership and Tenure / Land Reform / Land Use / Irrigation / Agriculture and Environment",
			"Q16" => "R&D / Agricultural Technology / Biofuels / Agricultural Extension Services",
			"Q17" => "Agriculture in International Trade",
			"Q18" => "Agricultural Policy / Food Policy",
			"Q19" => "Other"
		);
		$temp["&nbsp;&nbsp;Renewable Resources and Conservation"] = array(
			"Q20" => "General",
			"Q21" => "Demand and Supply / Prices",
			"Q22" => "Fishery / Aquaculture",
			"Q23" => "Forestry",
			"Q24" => "Land",
			"Q25" => "Water",
			"Q26" => "Recreational Aspects of Natural Resources",
			"Q27" => "Issues in International Trade",
			"Q28" => "Government Policy",
			"Q29" => "Other"
		);
		$temp["&nbsp;&nbsp;Nonrenewable Resources and Conservation"] = array(
			"Q30" => "General",
			"Q31" => "Demand and Supply / Prices",
			"Q32" => "Exhaustible Resources and Economic Development",
			"Q33" => "Resource Booms",
			"Q34" => "Natural Resources and Domestic and International Conflicts",
			"Q35" => "Hydrocarbon Resources",
			"Q37" => "Issues in International Trade",
			"Q38" => "Government Policy",
			"Q39" => "Other"
		);
		$temp["&nbsp;&nbsp;Energy"] = array(
			"Q40" => "General",
			"Q41" => "Demand and Supply / Prices",
			"Q42" => "Alternative Energy Sources",
			"Q43" => "Energy and the Macroeconomy",
			"Q47" => "Energy Forecasting",
			"Q48" => "Government Policy",
			"Q49" => "Other"
		);
		$temp["&nbsp;&nbsp;Environmental Economics"] = array(
			"Q50" => "General",
			"Q51" => "Valuation of Environmental Effects",
			"Q52" => "Pollution Control Adoption and Costs / Distributional Effects / Employment Effects",
			"Q53" => "Air Pollution / Water Pollution / Noise / Hazardous Waste / Solid Waste / Recycling",
			"Q54" => "Climate / Natural Disasters and Their Management / Global Warming",
			"Q55" => "Technological Innovation",
			"Q56" => "Environment and Development / Environment and Trade / Sustainability / Environmental Accounts and Accounting / Environmental Equity / Population Growth",
			"Q57" => "Ecological Economics: Ecosystem Services / Biodiversity Conservation / Bioeconomics / Industrial Ecology",
			"Q58" => "Government Policy",
			"Q59" => "Other"
		);
		$temp["R Urban, Rural, Regional, Real Estate, and Transportation Economics"] = array(
			"R00" => "General"
		);
		$temp["&nbsp;&nbsp;General Regional Economics"] = array(
			"R10" => "General",
			"R11" => "Regional Economic Activity: Growth, Development, Environmental Issues, and Changes",
			"R12" => "Size and Spatial Distributions of Regional Economic Activity",
			"R13" => "General Equilibrium and Welfare Economic Analysis of Regional Economies",
			"R14" => "Land Use Patterns",
			"R15" => "Econometric and Input-Output Models / Other Models",
			"R19" => "Other"
		);
		$temp["&nbsp;&nbsp;Household Analysis"] = array(
			"R20" => "General",
			"R21" => "Housing Demand",
			"R22" => "Other Demand",
			"R23" => "Regional Migration / Regional Labor Markets / Population / Neighborhood Characteristics",
			"R28" => "Government Policy",
			"R29" => "Other"
		);
		$temp["&nbsp;&nbsp;Real Estate Markets, Spatial Production Analysis, and Firm Location"] = array(
			"R30" => "General",
			"R31" => "Housing Supply and Markets",
			"R32" => "Other Spatial Production and Pricing Analysis",
			"R33" => "Nonagricultural and Nonresidential Real Estate Markets",
			"R38" => "Government Policy",
			"R39" => "Other"
		);
		$temp["&nbsp;&nbsp;Transportation Economics"] = array(
			"R40" => "General",
			"R41" => "Transportation: Demand, Supply, and Congestion / Travel Time / Safety and Accidents / Transportation Noise",
			"R42" => "Government and Private Investment Analysis / Road Maintenance / Transportation Planning",
			"R48" => "Government Pricing and Policy",
			"R49" => "Other"
		);
		$temp["&nbsp;&nbsp;Regional Government Analysis"] = array(
			"R50" => "General",
			"R51" => "Finance in Urban and Rural Economies",
			"R52" => "Land Use and Other Regulations",
			"R53" => "Public Facility Location Analysis / Public Investment and Capital Stock",
			"R58" => "Regional Development Planning and Policy",
			"R59" => "Other"
		);
		$temp["Y Miscellaneous Categories"] = array();
		$temp["&nbsp;&nbsp;Data: Tables and Charts"] = array(
			"Y10" => "Data: Tables and Charts "
		);
		$temp["&nbsp;&nbsp;Introductory Material"] = array(
			"Y20" => "Introductory Material"
		);
		$temp["&nbsp;&nbsp;Book Reviews (unclassified)"] = array(
			"Y30" => "Book Reviews (unclassified)"
		);
		$temp["&nbsp;&nbsp;Dissertations (unclassified)"] = array(
			"Y40" => "Dissertations (unclassified)"
		);
		$temp["&nbsp;&nbsp;Further Reading (unclassified)"] = array(
			"Y50" => "Further Reading (unclassified)"
		);
		$temp["&nbsp;&nbsp;Excerpts"] = array(
			"Y60" => "Excerpts"
		);
		$temp["&nbsp;&nbsp;No Author General Discussions"] = array(
			"Y70" => "No Author General Discussions"
		);
		$temp["&nbsp;&nbsp;Related Disciplines"] = array(
			"Y80" => "Related Disciplines"
		);
		$temp["&nbsp;&nbsp;Other"] = array(
			"Y90" => "Other",
			"Y91" => "Pictures and Maps",
			"Y92" => "Novels, Self-Help Books, etc."
		);
		$temp["Z Other Special Topics"] = array(
			"Z00" => "General"
		);
		$temp["&nbsp;&nbsp;Cultural Economics / Economic Sociology / Economic Anthropology"] = array(
			"Z10" => "General",
			"Z11" => "Economics of the Arts and Literature",
			"Z12" => "Religion",
			"Z13" => "Economic Sociology / Economic Anthropology / Social and Economic Stratification ",
			"Z18" => "Public Policy",
			"Z19" => "Other"
		);
		$temp["&nbsp;&nbsp;Sports Economics"] = array(
			"Z20" => "General",
			"Z21" => "Industry Studies",
			"Z22" => "Labor Issues",
			"Z23" => "Finance",
			"Z28" => "Policy",
			"Z29" => "Other"
		);
		$temp["&nbsp;&nbsp;Tourism Economics"] = array(
			"Z30" => "General",
			"Z31" => "Industry Studies",
			"Z32" => "Tourism and Development ",
			"Z33" => "Marketing and Finance ",
			"Z38" => "Policy ",
			"Z39" => "Other"
		);
		$this->JELClassification = $temp;
	}

}

?>
