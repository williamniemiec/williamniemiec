import 'package:uuid/uuid.dart';

class DocumentTemplate {
  final String id;
  final String name;
  final String description;
  final String category;
  final String content;
  final String thumbnailUrl;
  final DateTime createdAt;
  final bool isBuiltIn;
  final Map<String, dynamic> metadata;

  DocumentTemplate({
    String? id,
    required this.name,
    required this.description,
    required this.category,
    required this.content,
    this.thumbnailUrl = '',
    DateTime? createdAt,
    this.isBuiltIn = false,
    this.metadata = const {},
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now();

  DocumentTemplate copyWith({
    String? id,
    String? name,
    String? description,
    String? category,
    String? content,
    String? thumbnailUrl,
    DateTime? createdAt,
    bool? isBuiltIn,
    Map<String, dynamic>? metadata,
  }) {
    return DocumentTemplate(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      content: content ?? this.content,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      createdAt: createdAt ?? this.createdAt,
      isBuiltIn: isBuiltIn ?? this.isBuiltIn,
      metadata: metadata ?? this.metadata,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'category': category,
      'content': content,
      'thumbnailUrl': thumbnailUrl,
      'createdAt': createdAt.toIso8601String(),
      'isBuiltIn': isBuiltIn,
      'metadata': metadata,
    };
  }

  factory DocumentTemplate.fromJson(Map<String, dynamic> json) {
    return DocumentTemplate(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      category: json['category'],
      content: json['content'],
      thumbnailUrl: json['thumbnailUrl'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
      isBuiltIn: json['isBuiltIn'] ?? false,
      metadata: Map<String, dynamic>.from(json['metadata'] ?? {}),
    );
  }

  // Built-in templates
  static List<DocumentTemplate> getBuiltInTemplates() {
    return [
      DocumentTemplate(
        id: 'blank',
        name: 'Blank Document',
        description: 'Start with a blank document',
        category: 'Blank Document',
        content: '',
        isBuiltIn: true,
      ),
      DocumentTemplate(
        id: 'resume',
        name: 'Professional Resume',
        description: 'A clean, professional resume template',
        category: 'Resume',
        content: '''[Your Name]
[Your Address]
[City, State ZIP Code]
[Your Email]
[Your Phone Number]

OBJECTIVE
[Write a brief statement about your career goals]

EXPERIENCE
[Job Title] - [Company Name] ([Start Date] - [End Date])
• [Achievement or responsibility]
• [Achievement or responsibility]
• [Achievement or responsibility]

EDUCATION
[Degree] - [School Name] ([Graduation Year])
[Relevant coursework, honors, or activities]

SKILLS
• [Skill 1]
• [Skill 2]
• [Skill 3]''',
        isBuiltIn: true,
      ),
      DocumentTemplate(
        id: 'letter',
        name: 'Business Letter',
        description: 'Formal business letter template',
        category: 'Letter',
        content: '''[Your Name]
[Your Address]
[City, State ZIP Code]
[Your Email]
[Your Phone Number]

[Date]

[Recipient Name]
[Recipient Title]
[Company Name]
[Company Address]
[City, State ZIP Code]

Dear [Recipient Name],

[Opening paragraph - state the purpose of your letter]

[Body paragraph(s) - provide details, explanations, or supporting information]

[Closing paragraph - summarize your request or next steps]

Sincerely,

[Your Signature]
[Your Typed Name]''',
        isBuiltIn: true,
      ),
      DocumentTemplate(
        id: 'report',
        name: 'Project Report',
        description: 'Professional project report template',
        category: 'Report',
        content: '''PROJECT REPORT

Title: [Project Title]
Date: [Date]
Prepared by: [Your Name]
Department: [Department Name]

EXECUTIVE SUMMARY
[Brief overview of the project and key findings]

1. INTRODUCTION
[Background information and project objectives]

2. METHODOLOGY
[Approach and methods used]

3. FINDINGS
[Key results and discoveries]

4. RECOMMENDATIONS
[Suggested actions based on findings]

5. CONCLUSION
[Summary and final thoughts]

APPENDICES
[Supporting documents and data]''',
        isBuiltIn: true,
      ),
      DocumentTemplate(
        id: 'meeting_notes',
        name: 'Meeting Notes',
        description: 'Template for meeting minutes and notes',
        category: 'Meeting Notes',
        content: '''MEETING NOTES

Meeting: [Meeting Title]
Date: [Date]
Time: [Start Time] - [End Time]
Location: [Location/Platform]
Facilitator: [Name]

ATTENDEES
• [Name 1]
• [Name 2]
• [Name 3]

AGENDA
1. [Agenda Item 1]
2. [Agenda Item 2]
3. [Agenda Item 3]

DISCUSSION POINTS
[Key points discussed during the meeting]

ACTION ITEMS
• [Action Item 1] - Assigned to: [Name] - Due: [Date]
• [Action Item 2] - Assigned to: [Name] - Due: [Date]
• [Action Item 3] - Assigned to: [Name] - Due: [Date]

NEXT MEETING
Date: [Next Meeting Date]
Time: [Time]
Location: [Location]''',
        isBuiltIn: true,
      ),
    ];
  }
}