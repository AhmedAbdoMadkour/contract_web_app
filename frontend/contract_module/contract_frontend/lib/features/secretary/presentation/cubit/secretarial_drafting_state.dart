import 'package:equatable/equatable.dart';
import '../../data/model/document_template_model.dart';
import '../../data/model/template_clause_model.dart';

abstract class SecretarialDraftingState extends Equatable {
  const SecretarialDraftingState();
  
  @override
  List<Object?> get props => [];
}

class SecretarialDraftingInitial extends SecretarialDraftingState {}

class SecretarialDraftingLoading extends SecretarialDraftingState {}

class SecretarialDraftingLoaded extends SecretarialDraftingState {
  final List<DocumentTemplateModel> templates;
  final DocumentTemplateModel? selectedTemplate;
  final Set<String> selectedClauseIds;
  final String previewText;
  final bool isGeneratingPdf;
  final String? pdfUrl;

  const SecretarialDraftingLoaded({
    required this.templates,
    this.selectedTemplate,
    this.selectedClauseIds = const {},
    this.previewText = '',
    this.isGeneratingPdf = false,
    this.pdfUrl,
  });

  SecretarialDraftingLoaded copyWith({
    List<DocumentTemplateModel>? templates,
    DocumentTemplateModel? selectedTemplate,
    Set<String>? selectedClauseIds,
    String? previewText,
    bool? isGeneratingPdf,
    String? pdfUrl,
    bool clearPdf = false,
  }) {
    return SecretarialDraftingLoaded(
      templates: templates ?? this.templates,
      selectedTemplate: selectedTemplate ?? this.selectedTemplate,
      selectedClauseIds: selectedClauseIds ?? this.selectedClauseIds,
      previewText: previewText ?? this.previewText,
      isGeneratingPdf: isGeneratingPdf ?? this.isGeneratingPdf,
      pdfUrl: clearPdf ? null : (pdfUrl ?? this.pdfUrl),
    );
  }

  @override
  List<Object?> get props => [
        templates,
        selectedTemplate,
        selectedClauseIds,
        previewText,
        isGeneratingPdf,
        pdfUrl,
      ];
}

class SecretarialDraftingError extends SecretarialDraftingState {
  final String message;

  const SecretarialDraftingError(this.message);

  @override
  List<Object?> get props => [message];
}
