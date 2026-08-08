import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @loginTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in to SASHECO'**
  String get loginTitle;

  /// No description provided for @loginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome back! Please enter your details.'**
  String get loginSubtitle;

  /// No description provided for @emailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get emailLabel;

  /// No description provided for @passwordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordLabel;

  /// No description provided for @signInButton.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signInButton;

  /// No description provided for @rememberMe.
  ///
  /// In en, this message translates to:
  /// **'Remember me'**
  String get rememberMe;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password'**
  String get forgotPassword;

  /// No description provided for @sashecoDashboard.
  ///
  /// In en, this message translates to:
  /// **'SASHECO Dashboard'**
  String get sashecoDashboard;

  /// No description provided for @sasheco.
  ///
  /// In en, this message translates to:
  /// **'SASHECO'**
  String get sasheco;

  /// No description provided for @enterpriseHub.
  ///
  /// In en, this message translates to:
  /// **'Enterprise Hub'**
  String get enterpriseHub;

  /// No description provided for @jDoe.
  ///
  /// In en, this message translates to:
  /// **'J. Doe'**
  String get jDoe;

  /// No description provided for @analyst.
  ///
  /// In en, this message translates to:
  /// **'Analyst'**
  String get analyst;

  /// No description provided for @searchContractsDocuments.
  ///
  /// In en, this message translates to:
  /// **'Search contracts, documents...'**
  String get searchContractsDocuments;

  /// No description provided for @contractReviewTerminal.
  ///
  /// In en, this message translates to:
  /// **'Contract Review Terminal'**
  String get contractReviewTerminal;

  /// No description provided for @strategicInfrastructureExpansionPhase4.
  ///
  /// In en, this message translates to:
  /// **'Strategic Infrastructure Expansion - Phase 4'**
  String get strategicInfrastructureExpansionPhase4;

  /// No description provided for @pendingReview.
  ///
  /// In en, this message translates to:
  /// **'Pending Review'**
  String get pendingReview;

  /// No description provided for @submittedByLegalDepartment2HoursAgo.
  ///
  /// In en, this message translates to:
  /// **'Submitted by: Legal Department • 2 hours ago'**
  String get submittedByLegalDepartment2HoursAgo;

  /// No description provided for @attachDoc.
  ///
  /// In en, this message translates to:
  /// **'Attach Doc'**
  String get attachDoc;

  /// No description provided for @revisionRequestedRejected.
  ///
  /// In en, this message translates to:
  /// **'Revision Requested (Rejected).'**
  String get revisionRequestedRejected;

  /// No description provided for @requestRevision.
  ///
  /// In en, this message translates to:
  /// **'Request Revision'**
  String get requestRevision;

  /// No description provided for @contractApproved.
  ///
  /// In en, this message translates to:
  /// **'Contract Approved.'**
  String get contractApproved;

  /// No description provided for @approveContract.
  ///
  /// In en, this message translates to:
  /// **'Approve Contract'**
  String get approveContract;

  /// No description provided for @documentViewer.
  ///
  /// In en, this message translates to:
  /// **'Document Viewer'**
  String get documentViewer;

  /// No description provided for @masterServiceAgreement.
  ///
  /// In en, this message translates to:
  /// **'MASTER SERVICE AGREEMENT'**
  String get masterServiceAgreement;

  /// No description provided for @thisMasterServiceAgreementTheAgreementIsEnteredIntoAsOfOctober012024ByAndBetweenApexNexusProviderAndTheUndersignedClientClient.
  ///
  /// In en, this message translates to:
  /// **'This Master Service Agreement (the \"Agreement\") is entered into as of October 01, 2024, by and between Apex Nexus (\"Provider\") and the undersigned client (\"Client\").'**
  String
  get thisMasterServiceAgreementTheAgreementIsEnteredIntoAsOfOctober012024ByAndBetweenApexNexusProviderAndTheUndersignedClientClient;

  /// No description provided for @t1Services.
  ///
  /// In en, this message translates to:
  /// **'1. SERVICES'**
  String get t1Services;

  /// No description provided for @providerAgreesToPerformTheServicesDescribedInOneOrMoreStatementsOfWorkSowExecutedByBothParties.
  ///
  /// In en, this message translates to:
  /// **'Provider agrees to perform the services described in one or more Statements of Work (\"SOW\") executed by both parties.'**
  String
  get providerAgreesToPerformTheServicesDescribedInOneOrMoreStatementsOfWorkSowExecutedByBothParties;

  /// No description provided for @t2PaymentTerms.
  ///
  /// In en, this message translates to:
  /// **'2. PAYMENT TERMS'**
  String get t2PaymentTerms;

  /// No description provided for @clientShallPayProviderTheFeesSetForthInTheApplicableSowInvoicesArePayableWithin30DaysOfReceipt.
  ///
  /// In en, this message translates to:
  /// **'Client shall pay Provider the fees set forth in the applicable SOW. Invoices are payable within 30 days of receipt.'**
  String
  get clientShallPayProviderTheFeesSetForthInTheApplicableSowInvoicesArePayableWithin30DaysOfReceipt;

  /// No description provided for @t3Liability.
  ///
  /// In en, this message translates to:
  /// **'3. LIABILITY'**
  String get t3Liability;

  /// No description provided for @providersTotalLiabilityUnderThisAgreementShallNotExceedTheTotalAmountPaidByClientToProviderDuringTheTwelve12MonthsPrecedingTheClaim.
  ///
  /// In en, this message translates to:
  /// **'Provider\\\'s total liability under this Agreement shall not exceed the total amount paid by Client to Provider during the twelve (12) months preceding the claim.'**
  String
  get providersTotalLiabilityUnderThisAgreementShallNotExceedTheTotalAmountPaidByClientToProviderDuringTheTwelve12MonthsPrecedingTheClaim;

  /// No description provided for @aiRiskAssessment.
  ///
  /// In en, this message translates to:
  /// **'AI Risk Assessment'**
  String get aiRiskAssessment;

  /// No description provided for @overallRiskScore.
  ///
  /// In en, this message translates to:
  /// **'Overall Risk Score:'**
  String get overallRiskScore;

  /// No description provided for @medium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get medium;

  /// No description provided for @detectedDeviations.
  ///
  /// In en, this message translates to:
  /// **'Detected Deviations'**
  String get detectedDeviations;

  /// No description provided for @auditTrail.
  ///
  /// In en, this message translates to:
  /// **'Audit Trail'**
  String get auditTrail;

  /// No description provided for @searchContracts.
  ///
  /// In en, this message translates to:
  /// **'Search contracts...'**
  String get searchContracts;

  /// No description provided for @sashecoFlowContract.
  ///
  /// In en, this message translates to:
  /// **'Sasheco Flow contract'**
  String get sashecoFlowContract;

  /// No description provided for @t2024SashecoErp.
  ///
  /// In en, this message translates to:
  /// **'© 2024 SASHECO ERP.'**
  String get t2024SashecoErp;

  /// No description provided for @enterYourEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get enterYourEmail;

  /// No description provided for @enterYourPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get enterYourPassword;

  /// No description provided for @overview.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get overview;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @metricsDataLoaded.
  ///
  /// In en, this message translates to:
  /// **'Metrics Data Loaded'**
  String get metricsDataLoaded;

  /// No description provided for @projectCreatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Project created successfully!'**
  String get projectCreatedSuccessfully;

  /// No description provided for @projectStatusUpdatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Project status updated successfully!'**
  String get projectStatusUpdatedSuccessfully;

  /// No description provided for @contractDetails.
  ///
  /// In en, this message translates to:
  /// **'Contract Details'**
  String get contractDetails;

  /// No description provided for @projectAlphaTerminalExpansion.
  ///
  /// In en, this message translates to:
  /// **'Project: Alpha Terminal Expansion'**
  String get projectAlphaTerminalExpansion;

  /// No description provided for @updateStatus.
  ///
  /// In en, this message translates to:
  /// **'UPDATE STATUS'**
  String get updateStatus;

  /// No description provided for @addProject.
  ///
  /// In en, this message translates to:
  /// **'ADD PROJECT'**
  String get addProject;

  /// No description provided for @updateProjectStatus.
  ///
  /// In en, this message translates to:
  /// **'Update Project Status'**
  String get updateProjectStatus;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @create.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get create;

  /// No description provided for @contractItemsDefinition.
  ///
  /// In en, this message translates to:
  /// **'Contract Items Definition'**
  String get contractItemsDefinition;

  /// No description provided for @addItem.
  ///
  /// In en, this message translates to:
  /// **'Add Item'**
  String get addItem;

  /// No description provided for @itemId.
  ///
  /// In en, this message translates to:
  /// **'Item ID'**
  String get itemId;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @actions.
  ///
  /// In en, this message translates to:
  /// **'Actions'**
  String get actions;

  /// No description provided for @termsConditions.
  ///
  /// In en, this message translates to:
  /// **'Terms & Conditions'**
  String get termsConditions;

  /// No description provided for @pricingQuantities.
  ///
  /// In en, this message translates to:
  /// **'Pricing & Quantities'**
  String get pricingQuantities;

  /// No description provided for @qty.
  ///
  /// In en, this message translates to:
  /// **'QTY'**
  String get qty;

  /// No description provided for @unitPrice.
  ///
  /// In en, this message translates to:
  /// **'UNIT PRICE'**
  String get unitPrice;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'TOTAL'**
  String get total;

  /// No description provided for @projectDrawings.
  ///
  /// In en, this message translates to:
  /// **'Project Drawings'**
  String get projectDrawings;

  /// No description provided for @dragAndDropFilesHere.
  ///
  /// In en, this message translates to:
  /// **'Drag and drop files here'**
  String get dragAndDropFilesHere;

  /// No description provided for @browseFiles.
  ///
  /// In en, this message translates to:
  /// **'Browse Files'**
  String get browseFiles;

  /// No description provided for @newStatus.
  ///
  /// In en, this message translates to:
  /// **'New Status'**
  String get newStatus;

  /// No description provided for @projectName.
  ///
  /// In en, this message translates to:
  /// **'Project Name'**
  String get projectName;

  /// No description provided for @drawingsTechnicalSpecs.
  ///
  /// In en, this message translates to:
  /// **'Drawings & Technical Specs'**
  String get drawingsTechnicalSpecs;

  /// No description provided for @dragDropDrawingsHereOrClickToUpload.
  ///
  /// In en, this message translates to:
  /// **'Drag & Drop drawings here or click to upload'**
  String get dragDropDrawingsHereOrClickToUpload;

  /// No description provided for @supportedDwgIfcRvtPdf.
  ///
  /// In en, this message translates to:
  /// **'Supported: DWG, IFC, RVT, PDF'**
  String get supportedDwgIfcRvtPdf;

  /// No description provided for @itemizedEngineeringQuantities.
  ///
  /// In en, this message translates to:
  /// **'Itemized Engineering Quantities'**
  String get itemizedEngineeringQuantities;

  /// No description provided for @component.
  ///
  /// In en, this message translates to:
  /// **'Component'**
  String get component;

  /// No description provided for @specification.
  ///
  /// In en, this message translates to:
  /// **'Specification'**
  String get specification;

  /// No description provided for @quantityUnit.
  ///
  /// In en, this message translates to:
  /// **'Quantity Unit'**
  String get quantityUnit;

  /// No description provided for @foundationWalls.
  ///
  /// In en, this message translates to:
  /// **'Foundation Walls'**
  String get foundationWalls;

  /// No description provided for @t4000PsiRebar5.
  ///
  /// In en, this message translates to:
  /// **'4000 PSI, Rebar #5'**
  String get t4000PsiRebar5;

  /// No description provided for @t120M3.
  ///
  /// In en, this message translates to:
  /// **'120 m3'**
  String get t120M3;

  /// No description provided for @steelColumns.
  ///
  /// In en, this message translates to:
  /// **'Steel Columns'**
  String get steelColumns;

  /// No description provided for @w12x40A992.
  ///
  /// In en, this message translates to:
  /// **'W12x40, A992'**
  String get w12x40A992;

  /// No description provided for @t45Tons.
  ///
  /// In en, this message translates to:
  /// **'45 tons'**
  String get t45Tons;

  /// No description provided for @roofDecking.
  ///
  /// In en, this message translates to:
  /// **'Roof Decking'**
  String get roofDecking;

  /// No description provided for @t1520gauge.
  ///
  /// In en, this message translates to:
  /// **'1.5\" 20-Gauge'**
  String get t1520gauge;

  /// No description provided for @t5000Sqft.
  ///
  /// In en, this message translates to:
  /// **'5,000 sqft'**
  String get t5000Sqft;

  /// No description provided for @complianceStandards.
  ///
  /// In en, this message translates to:
  /// **'Compliance & Standards'**
  String get complianceStandards;

  /// No description provided for @contractEfficiency.
  ///
  /// In en, this message translates to:
  /// **'Contract Efficiency'**
  String get contractEfficiency;

  /// No description provided for @t92.
  ///
  /// In en, this message translates to:
  /// **'92%'**
  String get t92;

  /// No description provided for @designSpecificationsAlignPerfectlyWithStandardMaterialSizesReducingWaste.
  ///
  /// In en, this message translates to:
  /// **'Design specifications align perfectly with standard material sizes, reducing waste.'**
  String
  get designSpecificationsAlignPerfectlyWithStandardMaterialSizesReducingWaste;

  /// No description provided for @viewOptimizationReport.
  ///
  /// In en, this message translates to:
  /// **'View Optimization Report'**
  String get viewOptimizationReport;

  /// No description provided for @quickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get quickActions;

  /// No description provided for @t1DefineContractItemsPricesQuantities.
  ///
  /// In en, this message translates to:
  /// **'1. Define Contract Items, Prices & Quantities'**
  String get t1DefineContractItemsPricesQuantities;

  /// No description provided for @itemName.
  ///
  /// In en, this message translates to:
  /// **'Item Name'**
  String get itemName;

  /// No description provided for @quantity.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get quantity;

  /// No description provided for @steelBeams.
  ///
  /// In en, this message translates to:
  /// **'Steel Beams'**
  String get steelBeams;

  /// No description provided for @t100.
  ///
  /// In en, this message translates to:
  /// **'100'**
  String get t100;

  /// No description provided for @concrete.
  ///
  /// In en, this message translates to:
  /// **'Concrete'**
  String get concrete;

  /// No description provided for @t500M3.
  ///
  /// In en, this message translates to:
  /// **'500 m3'**
  String get t500M3;

  /// No description provided for @pricingAnalysisUnitRates.
  ///
  /// In en, this message translates to:
  /// **'Pricing Analysis & Unit Rates'**
  String get pricingAnalysisUnitRates;

  /// No description provided for @structuralSteel.
  ///
  /// In en, this message translates to:
  /// **'Structural Steel'**
  String get structuralSteel;

  /// No description provided for @granularPriceBreakdown.
  ///
  /// In en, this message translates to:
  /// **'Granular Price Breakdown'**
  String get granularPriceBreakdown;

  /// No description provided for @resourceItem.
  ///
  /// In en, this message translates to:
  /// **'Resource Item'**
  String get resourceItem;

  /// No description provided for @unitRate.
  ///
  /// In en, this message translates to:
  /// **'Unit Rate'**
  String get unitRate;

  /// No description provided for @volumeDiscount.
  ///
  /// In en, this message translates to:
  /// **'Volume Discount'**
  String get volumeDiscount;

  /// No description provided for @contractTotal.
  ///
  /// In en, this message translates to:
  /// **'Contract Total'**
  String get contractTotal;

  /// No description provided for @rateTrend.
  ///
  /// In en, this message translates to:
  /// **'Rate Trend'**
  String get rateTrend;

  /// No description provided for @t5100t.
  ///
  /// In en, this message translates to:
  /// **'5% (>100t)'**
  String get t5100t;

  /// No description provided for @readymixConcrete.
  ///
  /// In en, this message translates to:
  /// **'Ready-Mix Concrete'**
  String get readymixConcrete;

  /// No description provided for @t2500m3.
  ///
  /// In en, this message translates to:
  /// **'2% (>500m3)'**
  String get t2500m3;

  /// No description provided for @rebar.
  ///
  /// In en, this message translates to:
  /// **'Rebar'**
  String get rebar;

  /// No description provided for @none.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get none;

  /// No description provided for @t2TermsAndConditions.
  ///
  /// In en, this message translates to:
  /// **'2. Terms and Conditions'**
  String get t2TermsAndConditions;

  /// No description provided for @enterEngineeringSpecificTerms.
  ///
  /// In en, this message translates to:
  /// **'Enter engineering specific terms...'**
  String get enterEngineeringSpecificTerms;

  /// No description provided for @contracts.
  ///
  /// In en, this message translates to:
  /// **'Contracts'**
  String get contracts;

  /// No description provided for @sashecoFinancial.
  ///
  /// In en, this message translates to:
  /// **'SASHECO Financial'**
  String get sashecoFinancial;

  /// No description provided for @sashecoInfrastructureContract.
  ///
  /// In en, this message translates to:
  /// **'SASHECO Infrastructure Contract'**
  String get sashecoInfrastructureContract;

  /// No description provided for @active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active;

  /// No description provided for @exportPdf.
  ///
  /// In en, this message translates to:
  /// **'Export PDF'**
  String get exportPdf;

  /// No description provided for @processingPayment.
  ///
  /// In en, this message translates to:
  /// **'Processing Payment...'**
  String get processingPayment;

  /// No description provided for @processPayment.
  ///
  /// In en, this message translates to:
  /// **'Process Payment'**
  String get processPayment;

  /// No description provided for @financialOverview.
  ///
  /// In en, this message translates to:
  /// **'Financial Overview'**
  String get financialOverview;

  /// No description provided for @disbursementProgress.
  ///
  /// In en, this message translates to:
  /// **'Disbursement Progress'**
  String get disbursementProgress;

  /// No description provided for @t68Completed.
  ///
  /// In en, this message translates to:
  /// **'68% Completed'**
  String get t68Completed;

  /// No description provided for @keyTerms.
  ///
  /// In en, this message translates to:
  /// **'Key Terms'**
  String get keyTerms;

  /// No description provided for @paymentScheduleMilestones.
  ///
  /// In en, this message translates to:
  /// **'Payment Schedule & Milestones'**
  String get paymentScheduleMilestones;

  /// No description provided for @allStatuses.
  ///
  /// In en, this message translates to:
  /// **'All Statuses'**
  String get allStatuses;

  /// No description provided for @milestone.
  ///
  /// In en, this message translates to:
  /// **'MILESTONE'**
  String get milestone;

  /// No description provided for @dueDate.
  ///
  /// In en, this message translates to:
  /// **'DUE DATE'**
  String get dueDate;

  /// No description provided for @amount.
  ///
  /// In en, this message translates to:
  /// **'AMOUNT'**
  String get amount;

  /// No description provided for @action.
  ///
  /// In en, this message translates to:
  /// **'ACTION'**
  String get action;

  /// No description provided for @review.
  ///
  /// In en, this message translates to:
  /// **'Review'**
  String get review;

  /// No description provided for @totalContractValue.
  ///
  /// In en, this message translates to:
  /// **'TOTAL CONTRACT VALUE'**
  String get totalContractValue;

  /// No description provided for @disbursedAmount.
  ///
  /// In en, this message translates to:
  /// **'DISBURSED AMOUNT'**
  String get disbursedAmount;

  /// No description provided for @remainingBalance.
  ///
  /// In en, this message translates to:
  /// **'REMAINING BALANCE'**
  String get remainingBalance;

  /// No description provided for @latePaymentPenalties.
  ///
  /// In en, this message translates to:
  /// **'Late Payment Penalties'**
  String get latePaymentPenalties;

  /// No description provided for @paymentWindows.
  ///
  /// In en, this message translates to:
  /// **'Payment Windows'**
  String get paymentWindows;

  /// No description provided for @trancheASiteSetup.
  ///
  /// In en, this message translates to:
  /// **'Tranche A - Site setup'**
  String get trancheASiteSetup;

  /// No description provided for @trancheB1Pouring.
  ///
  /// In en, this message translates to:
  /// **'Tranche B1 - Pouring'**
  String get trancheB1Pouring;

  /// No description provided for @trancheB2SteelWorkCompletion.
  ///
  /// In en, this message translates to:
  /// **'Tranche B2 - Steel work completion'**
  String get trancheB2SteelWorkCompletion;

  /// No description provided for @trancheCInspectionCleared.
  ///
  /// In en, this message translates to:
  /// **'Tranche C - Inspection cleared'**
  String get trancheCInspectionCleared;

  /// No description provided for @financialDepartment.
  ///
  /// In en, this message translates to:
  /// **'Financial Department'**
  String get financialDepartment;

  /// No description provided for @reviewFinancialInformationPaymentTerms.
  ///
  /// In en, this message translates to:
  /// **'Review Financial Information & Payment Terms.'**
  String get reviewFinancialInformationPaymentTerms;

  /// No description provided for @contractFinancialReview.
  ///
  /// In en, this message translates to:
  /// **'Contract Financial Review'**
  String get contractFinancialReview;

  /// No description provided for @t1FinancialInformationOverview.
  ///
  /// In en, this message translates to:
  /// **'1. Financial Information Overview'**
  String get t1FinancialInformationOverview;

  /// No description provided for @t2TermsAndConditionsFinancial.
  ///
  /// In en, this message translates to:
  /// **'2. Terms and Conditions (Financial)'**
  String get t2TermsAndConditionsFinancial;

  /// No description provided for @t3PaymentTermsSchedule.
  ///
  /// In en, this message translates to:
  /// **'3. Payment Terms Schedule'**
  String get t3PaymentTermsSchedule;

  /// No description provided for @percentage.
  ///
  /// In en, this message translates to:
  /// **'Percentage'**
  String get percentage;

  /// No description provided for @mobilization.
  ///
  /// In en, this message translates to:
  /// **'Mobilization'**
  String get mobilization;

  /// No description provided for @t10.
  ///
  /// In en, this message translates to:
  /// **'10%'**
  String get t10;

  /// No description provided for @pending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pending;

  /// No description provided for @t50Completion.
  ///
  /// In en, this message translates to:
  /// **'50% Completion'**
  String get t50Completion;

  /// No description provided for @t40.
  ///
  /// In en, this message translates to:
  /// **'40%'**
  String get t40;

  /// No description provided for @notStarted.
  ///
  /// In en, this message translates to:
  /// **'Not Started'**
  String get notStarted;

  /// No description provided for @approveFinancials.
  ///
  /// In en, this message translates to:
  /// **'Approve Financials'**
  String get approveFinancials;

  /// No description provided for @enterFinancialTerms.
  ///
  /// In en, this message translates to:
  /// **'Enter financial terms...'**
  String get enterFinancialTerms;

  /// No description provided for @executiveWorkspace.
  ///
  /// In en, this message translates to:
  /// **'Executive Workspace'**
  String get executiveWorkspace;

  /// No description provided for @contractDraftingServiceLevelAgreementQ4.
  ///
  /// In en, this message translates to:
  /// **'Contract Drafting: Service Level Agreement - Q4'**
  String get contractDraftingServiceLevelAgreementQ4;

  /// No description provided for @complianceVerified.
  ///
  /// In en, this message translates to:
  /// **'Compliance Verified'**
  String get complianceVerified;

  /// No description provided for @saveDraft.
  ///
  /// In en, this message translates to:
  /// **'Save Draft'**
  String get saveDraft;

  /// No description provided for @publish.
  ///
  /// In en, this message translates to:
  /// **'Publish'**
  String get publish;

  /// No description provided for @aiAssist.
  ///
  /// In en, this message translates to:
  /// **'AI Assist'**
  String get aiAssist;

  /// No description provided for @referenceDocuments.
  ///
  /// In en, this message translates to:
  /// **'Reference Documents'**
  String get referenceDocuments;

  /// No description provided for @addReference.
  ///
  /// In en, this message translates to:
  /// **'Add Reference'**
  String get addReference;

  /// No description provided for @smartSuggestions.
  ///
  /// In en, this message translates to:
  /// **'Smart Suggestions'**
  String get smartSuggestions;

  /// No description provided for @missingClauseConsiderAddingAForceMajeureSectionToLimitLiabilityDuringUnforeseenCircumstancesGivenTheQ4TimelineRisks.
  ///
  /// In en, this message translates to:
  /// **'Missing Clause: Consider adding a \\\'Force Majeure\\\' section to limit liability during unforeseen circumstances given the Q4 timeline risks.'**
  String
  get missingClauseConsiderAddingAForceMajeureSectionToLimitLiabilityDuringUnforeseenCircumstancesGivenTheQ4TimelineRisks;

  /// No description provided for @reviewSuggestions.
  ///
  /// In en, this message translates to:
  /// **'Review Suggestions'**
  String get reviewSuggestions;

  /// No description provided for @siteLocationUpdatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Site location updated successfully!'**
  String get siteLocationUpdatedSuccessfully;

  /// No description provided for @inframanagerEnterpriseConsole.
  ///
  /// In en, this message translates to:
  /// **'InfraManager Enterprise Console'**
  String get inframanagerEnterpriseConsole;

  /// No description provided for @greenValleyInfrastructure.
  ///
  /// In en, this message translates to:
  /// **'Green Valley Infrastructure'**
  String get greenValleyInfrastructure;

  /// No description provided for @prj2024089.
  ///
  /// In en, this message translates to:
  /// **'#PRJ-2024-089'**
  String get prj2024089;

  /// No description provided for @activeConstructionPhase.
  ///
  /// In en, this message translates to:
  /// **'Active Construction Phase'**
  String get activeConstructionPhase;

  /// No description provided for @exportData.
  ///
  /// In en, this message translates to:
  /// **'Export Data'**
  String get exportData;

  /// No description provided for @updateLocation.
  ///
  /// In en, this message translates to:
  /// **'Update Location'**
  String get updateLocation;

  /// No description provided for @manageSite.
  ///
  /// In en, this message translates to:
  /// **'Manage Site'**
  String get manageSite;

  /// No description provided for @updateSiteLocation.
  ///
  /// In en, this message translates to:
  /// **'Update Site Location'**
  String get updateSiteLocation;

  /// No description provided for @contractActivity.
  ///
  /// In en, this message translates to:
  /// **'Contract Activity'**
  String get contractActivity;

  /// No description provided for @siteReadiness.
  ///
  /// In en, this message translates to:
  /// **'Site Readiness'**
  String get siteReadiness;

  /// No description provided for @viewFullChecklist.
  ///
  /// In en, this message translates to:
  /// **'View Full Checklist'**
  String get viewFullChecklist;

  /// No description provided for @totalContracts.
  ///
  /// In en, this message translates to:
  /// **'Total Contracts'**
  String get totalContracts;

  /// No description provided for @totalAddenda.
  ///
  /// In en, this message translates to:
  /// **'Total Addenda'**
  String get totalAddenda;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search...'**
  String get search;

  /// No description provided for @latitude.
  ///
  /// In en, this message translates to:
  /// **'Latitude'**
  String get latitude;

  /// No description provided for @longitude.
  ///
  /// In en, this message translates to:
  /// **'Longitude'**
  String get longitude;

  /// No description provided for @foundationClear.
  ///
  /// In en, this message translates to:
  /// **'Foundation Clear'**
  String get foundationClear;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// No description provided for @materialLog.
  ///
  /// In en, this message translates to:
  /// **'Material Log'**
  String get materialLog;

  /// No description provided for @inProgress.
  ///
  /// In en, this message translates to:
  /// **'In Progress'**
  String get inProgress;

  /// No description provided for @safetyAudit.
  ///
  /// In en, this message translates to:
  /// **'Safety Audit'**
  String get safetyAudit;

  /// No description provided for @scheduled.
  ///
  /// In en, this message translates to:
  /// **'Scheduled'**
  String get scheduled;

  /// No description provided for @createUser.
  ///
  /// In en, this message translates to:
  /// **'Create User'**
  String get createUser;

  /// No description provided for @provisionANewUserAccountAndAssignSystemAccessPermissions.
  ///
  /// In en, this message translates to:
  /// **'Provision a new user account and assign system access permissions.'**
  String get provisionANewUserAccountAndAssignSystemAccessPermissions;

  /// No description provided for @userDetails.
  ///
  /// In en, this message translates to:
  /// **'User Details'**
  String get userDetails;

  /// No description provided for @positionRole.
  ///
  /// In en, this message translates to:
  /// **'Position / Role'**
  String get positionRole;

  /// No description provided for @financialAnalyst.
  ///
  /// In en, this message translates to:
  /// **'Financial Analyst'**
  String get financialAnalyst;

  /// No description provided for @projectManager.
  ///
  /// In en, this message translates to:
  /// **'Project Manager'**
  String get projectManager;

  /// No description provided for @systemAdministrator.
  ///
  /// In en, this message translates to:
  /// **'System Administrator'**
  String get systemAdministrator;

  /// No description provided for @selectRole.
  ///
  /// In en, this message translates to:
  /// **'Select Role'**
  String get selectRole;

  /// No description provided for @accessPermissions.
  ///
  /// In en, this message translates to:
  /// **'Access Permissions'**
  String get accessPermissions;

  /// No description provided for @pleaseFillAllRequiredFields.
  ///
  /// In en, this message translates to:
  /// **'Please fill all required fields'**
  String get pleaseFillAllRequiredFields;

  /// No description provided for @module.
  ///
  /// In en, this message translates to:
  /// **'Module'**
  String get module;

  /// No description provided for @view.
  ///
  /// In en, this message translates to:
  /// **'VIEW'**
  String get view;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'EDIT'**
  String get edit;

  /// No description provided for @admin.
  ///
  /// In en, this message translates to:
  /// **'ADMIN'**
  String get admin;

  /// No description provided for @globalPermissionsControl.
  ///
  /// In en, this message translates to:
  /// **'Global Permissions Control'**
  String get globalPermissionsControl;

  /// No description provided for @manageDefaultAccessLevelsAcrossThePlatform.
  ///
  /// In en, this message translates to:
  /// **'Manage default access levels across the platform.'**
  String get manageDefaultAccessLevelsAcrossThePlatform;

  /// No description provided for @accessMatrix.
  ///
  /// In en, this message translates to:
  /// **'Access Matrix'**
  String get accessMatrix;

  /// No description provided for @role.
  ///
  /// In en, this message translates to:
  /// **'ROLE'**
  String get role;

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// No description provided for @searchRolesOrModules.
  ///
  /// In en, this message translates to:
  /// **'Search roles or modules...'**
  String get searchRolesOrModules;

  /// No description provided for @addNewVendor.
  ///
  /// In en, this message translates to:
  /// **'Add New Vendor'**
  String get addNewVendor;

  /// No description provided for @saveVendor.
  ///
  /// In en, this message translates to:
  /// **'Save Vendor'**
  String get saveVendor;

  /// No description provided for @noVendorsFound.
  ///
  /// In en, this message translates to:
  /// **'No vendors found.'**
  String get noVendorsFound;

  /// No description provided for @vendorManagement.
  ///
  /// In en, this message translates to:
  /// **'Vendor Management'**
  String get vendorManagement;

  /// No description provided for @addVendor.
  ///
  /// In en, this message translates to:
  /// **'Add Vendor'**
  String get addVendor;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @contactPerson.
  ///
  /// In en, this message translates to:
  /// **'Contact Person'**
  String get contactPerson;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phone;

  /// No description provided for @joined.
  ///
  /// In en, this message translates to:
  /// **'Joined'**
  String get joined;

  /// No description provided for @deleteVendor.
  ///
  /// In en, this message translates to:
  /// **'Delete Vendor'**
  String get deleteVendor;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
