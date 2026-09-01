import 'package:flutter_bloc/flutter_bloc.dart';
import 'secretarial_drafting_state.dart';
import '../../data/model/document_template_model.dart';
import '../../data/model/template_clause_model.dart';

class SecretarialDraftingCubit extends Cubit<SecretarialDraftingState> {
  SecretarialDraftingCubit() : super(SecretarialDraftingInitial());

  void loadTemplates() async {
    emit(SecretarialDraftingLoading());
    try {
      // Mock network delay
      await Future.delayed(const Duration(seconds: 1));

      final mockTemplates = [
        DocumentTemplateModel(
          id: 't1',
          name: 'Standard Employment Contract',
          description: 'Basic contract for full-time employees.',
          clauses: [
            TemplateClauseModel(id: 'c1', title: 'Position and Duties', content: 'The Employee will be employed as [Position].', isMandatory: true),
            TemplateClauseModel(id: 'c2', title: 'Compensation', content: 'The Employee will be paid a base salary of [Salary].', isMandatory: true),
            TemplateClauseModel(id: 'c3', title: 'Non-Compete', content: 'The Employee agrees not to compete for 1 year post-employment.', isMandatory: false),
          ],
        ),
        DocumentTemplateModel(
          id: 't2',
          name: 'Non-Disclosure Agreement',
          description: 'Standard NDA for contractors.',
          clauses: [
            TemplateClauseModel(id: 'c4', title: 'Definition of Confidential Information', content: 'Confidential Information includes all proprietary data.', isMandatory: true),
            TemplateClauseModel(id: 'c5', title: 'Obligations', content: 'Receiving party must not disclose the information.', isMandatory: true),
            TemplateClauseModel(id: 'c6', title: 'Term', content: 'This agreement lasts for 5 years.', isMandatory: false),
          ],
        ),
      ];

      emit(SecretarialDraftingLoaded(templates: mockTemplates));
    } catch (e) {
      emit(SecretarialDraftingError(e.toString()));
    }
  }

  void selectTemplate(DocumentTemplateModel template) {
    if (state is SecretarialDraftingLoaded) {
      final currentState = state as SecretarialDraftingLoaded;
      
      // Auto-select mandatory clauses
      final mandatoryClauseIds = template.clauses
          .where((c) => c.isMandatory)
          .map((c) => c.id)
          .toSet();

      emit(currentState.copyWith(
        selectedTemplate: template,
        selectedClauseIds: mandatoryClauseIds,
        previewText: '',
        clearPdf: true,
      ));
    }
  }

  void toggleClause(String clauseId, bool isSelected) {
    if (state is SecretarialDraftingLoaded) {
      final currentState = state as SecretarialDraftingLoaded;
      final newSelectedIds = Set<String>.from(currentState.selectedClauseIds);
      
      if (isSelected) {
        newSelectedIds.add(clauseId);
      } else {
        newSelectedIds.remove(clauseId);
      }

      emit(currentState.copyWith(selectedClauseIds: newSelectedIds));
    }
  }

  void previewDocument() {
    if (state is SecretarialDraftingLoaded) {
      final currentState = state as SecretarialDraftingLoaded;
      if (currentState.selectedTemplate == null) return;

      final selectedClauses = currentState.selectedTemplate!.clauses
          .where((c) => currentState.selectedClauseIds.contains(c.id))
          .toList();

      StringBuffer buffer = StringBuffer();
      buffer.writeln('# ${currentState.selectedTemplate!.name}\n');
      
      for (var clause in selectedClauses) {
        buffer.writeln('## ${clause.title}');
        buffer.writeln('${clause.content}\n');
      }

      emit(currentState.copyWith(previewText: buffer.toString()));
    }
  }

  void generatePdf() async {
    if (state is SecretarialDraftingLoaded) {
      final currentState = state as SecretarialDraftingLoaded;
      emit(currentState.copyWith(isGeneratingPdf: true, clearPdf: true));
      
      try {
        // Mock API call for PDF generation
        await Future.delayed(const Duration(seconds: 2));
        
        // Mock PDF URL
        final mockPdfUrl = 'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf';
        
        emit((state as SecretarialDraftingLoaded).copyWith(
          isGeneratingPdf: false,
          pdfUrl: mockPdfUrl,
        ));
      } catch (e) {
        emit(SecretarialDraftingError(e.toString()));
      }
    }
  }
}
