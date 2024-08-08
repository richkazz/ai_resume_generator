import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myapp/models/resume.dart';
import 'package:myapp/services/resume_service.dart';
import 'package:myapp/spacing/app_spacing.dart';
import 'package:myapp/util/resume_to_pdf.dart';
import 'package:myapp/widgets/side_navigation_button.dart';
import 'package:provider/provider.dart';

class ResumePreview extends StatefulWidget {
  final Resume resume;

  const ResumePreview({super.key, required this.resume});

  @override
  State<ResumePreview> createState() => _ResumePreviewState();
}

class _ResumePreviewState extends State<ResumePreview> {
  final ScrollController _scrollController = ScrollController();
  final List<SectionItem> _sections = [
    SectionItem(key: GlobalKey(), icon: Icons.person), // Personal Information
    SectionItem(key: GlobalKey(), icon: Icons.flag), // Objective
    SectionItem(key: GlobalKey(), icon: Icons.account_circle), // Profile
    SectionItem(key: GlobalKey(), icon: Icons.star), // Skills
    SectionItem(key: GlobalKey(), icon: Icons.work), // Work Experience
    SectionItem(key: GlobalKey(), icon: Icons.school), // Education
    SectionItem(key: GlobalKey(), icon: Icons.folder), // Projects
    SectionItem(key: GlobalKey(), icon: Icons.verified_user), // Certifications
    SectionItem(
        key: GlobalKey(), icon: Icons.contact_mail), // Contact Information
    SectionItem(key: GlobalKey(), icon: Icons.group), // Referee
  ];
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.blueAccent,
        ),
      ),
    );
  }

  Future<void> _generatePDF(BuildContext context, Resume resume) async {
    await ResumeToPDF().generatePDF(resume);
  }

  Future<void> _exportProfile(BuildContext context, Resume resume) async {
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Exporting your profile')));
    await ExportJsonProfile().generateJsonProfile(resume);
  }

  Future<void> _generateDOCX(BuildContext context, Resume resume) async {
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Generating document')));
    await ResumeToDOCX.generateDOCX(resume);
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Colors.blueAccent),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 16),
            softWrap: true,
          ),
        ),
      ],
    );
  }

  Widget _buildListTile(String title, String subtitle) {
    return ListTile(
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle),
    );
  }

  List<Widget> _buildWorkExperienceList() {
    return widget.resume.workExperience.map((workExperience) {
      return Card(
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        elevation: 4.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                workExperience.position ?? '',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.blueAccent,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.business, color: Colors.grey[600]),
                  const SizedBox(width: 8),
                  Text(
                    workExperience.company ?? '',
                    style: const TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.date_range, color: Colors.grey[600]),
                  const SizedBox(width: 8),
                  Text(
                    '${workExperience.startDate == null ? '' : DateFormat('MMM yyyy').format(workExperience.startDate!)} - ${workExperience.endDate != null ? DateFormat('MMM yyyy').format(workExperience.endDate!) : 'Present'}',
                    style: const TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Text(
                'Responsibilities:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              ...workExperience.responsibilities
                  .map((responsibility) => ListOfStringItemWidget(
                        item: responsibility,
                      )),
            ],
          ),
        ),
      );
    }).toList();
  }

  Widget _buildDateRange(DateTime? start, DateTime? end) {
    final dateFormat = DateFormat('MMM yyyy');
    String startDate = start != null ? dateFormat.format(start) : 'N/A';
    String endDate = end != null ? dateFormat.format(end) : 'Present';
    return Text('$startDate - $endDate');
  }

  Widget _buildSection(GlobalKey key, String title, List<Widget> children) {
    return Container(
      key: key,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(title),
          const SizedBox(height: 8),
          ...children,
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resume Preview'),
        actions: [
          Tooltip(
            message: 'Export profile as json',
            child: IconButton(
              icon: const Icon(Icons.import_export),
              onPressed: () => _exportProfile(context, widget.resume),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            onPressed: () => _generatePDF(context, widget.resume),
          ),
          IconButton(
            icon: const Icon(Icons.document_scanner),
            onPressed: () => _generateDOCX(context, widget.resume),
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSection(_sections[0].key, 'Personal Information', [
                  // Personal Information
                  if (widget.resume.name != null)
                    _buildInfoRow(Icons.person, widget.resume.name!),
                  if (widget.resume.address != null)
                    _buildInfoRow(Icons.location_on, widget.resume.address!),
                  if (widget.resume.phoneNumber != null)
                    _buildInfoRow(Icons.phone, widget.resume.phoneNumber!),
                  if (widget.resume.email != null)
                    _buildInfoRow(Icons.email, widget.resume.email!),

                  // Objective
                  if (widget.resume.objective != null) ...[
                    _buildSection(_sections[1].key, 'Objective', [
                      Text(widget.resume.objective!,
                          style: const TextStyle(fontSize: 16)),
                    ]),
                  ],
                ]),
                // Profile
                if (widget.resume.profile != null) ...[
                  _buildSection(_sections[2].key, 'Profile', [
                    Card(
                        child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      child: Text(widget.resume.profile!,
                          style: const TextStyle(fontSize: 16)),
                    )),
                  ]),
                ],
                // Skills
                if (widget.resume.skills.isNotEmpty) ...[
                  _buildSection(_sections[3].key, 'Skills', [
                    Wrap(
                      spacing: 8.0,
                      runSpacing: 4.0,
                      children: widget.resume.skills
                          .map((skill) => Chip(
                                label: Text(skill),
                                backgroundColor: Theme.of(context)
                                    .colorScheme
                                    .primaryContainer,
                              ))
                          .toList(),
                    ),
                  ]),
                ],

                // Work Experience
                if (widget.resume.workExperience.isNotEmpty) ...[
                  _buildSection(_sections[4].key, 'Work Experience',
                      _buildWorkExperienceList()),
                ],

                // Education
                if (widget.resume.education.isNotEmpty) ...[
                  _buildSection(
                    _sections[5].key,
                    'Education',
                    widget.resume.education
                        .map((edu) => Card(
                              margin: const EdgeInsets.symmetric(vertical: 8.0),
                              elevation: 4.0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildListTile(edu.institution ?? 'N/A',
                                        edu.degree ?? 'N/A'),
                                    _buildDateRange(null, edu.graduationDate),
                                  ],
                                ),
                              ),
                            ))
                        .toList(),
                  )
                ],

                // Projects
                if (widget.resume.projects.isNotEmpty) ...[
                  _buildSection(
                    _sections[6].key,
                    'Projects',
                    widget.resume.projects
                        .map((project) => Card(
                              margin: const EdgeInsets.symmetric(vertical: 8.0),
                              elevation: 4.0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(project.name ?? 'N/A',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18)),
                                    const SizedBox(height: 8),
                                    if (project.description != null)
                                      Text(project.description!,
                                          style: const TextStyle(fontSize: 16)),
                                    const SizedBox(height: 8),
                                    Wrap(
                                      spacing: 8.0,
                                      runSpacing: 4.0,
                                      children: project.technologies
                                          .map((tech) => Chip(
                                                label: Text(tech),
                                                backgroundColor:
                                                    Theme.of(context)
                                                        .colorScheme
                                                        .primaryContainer,
                                              ))
                                          .toList(),
                                    ),
                                    const SizedBox(height: 8),
                                    if (project.keyFeatures.isNotEmpty)
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: project.keyFeatures
                                            .map((feature) =>
                                                ListOfStringItemWidget(
                                                  item: feature,
                                                ))
                                            .toList(),
                                      ),
                                  ],
                                ),
                              ),
                            ))
                        .toList(),
                  ),
                ],

                // Certifications
                if (widget.resume.certifications.isNotEmpty) ...[
                  _buildSection(
                    _sections[7].key,
                    'Certifications',
                    widget.resume.certifications
                        .map((cert) => SizedBox(
                              width: double.infinity,
                              child: Card(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                elevation: 4.0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(cert.name ?? 'N/A',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18)),
                                      const SizedBox(height: 8),
                                      Text(cert.organization ?? 'N/A',
                                          style: const TextStyle(fontSize: 16)),
                                      const SizedBox(height: 8),
                                      _buildDateRange(null, cert.date),
                                      const SizedBox(height: 8),
                                      if (cert.verificationLink != null)
                                        Text(cert.verificationLink!,
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary)),
                                    ],
                                  ),
                                ),
                              ),
                            ))
                        .toList(),
                  ),
                ],

                // Contact Information
                if (widget.resume.contactInformation != null) ...[
                  if (widget.resume.contactInformation!.linkedin != null)
                    _buildSection(
                      _sections[8].key,
                      'Contact Information',
                      [
                        _buildInfoRow(Icons.link,
                            widget.resume.contactInformation!.linkedin!)
                      ],
                    ),
                ],

                // Referee
                if (widget.resume.referee != null) ...[
                  _buildSection(
                    _sections[9].key,
                    'Referee',
                    [
                      Text(widget.resume.referee!,
                          style: const TextStyle(fontSize: 16))
                    ],
                  ),
                ],
              ],
            ),
          ),
          SideNavigationButton(
            sections: _sections,
            scrollController: _scrollController,
          ),
        ],
      ),
    );
  }
}

class ListOfStringItemWidget extends StatelessWidget {
  const ListOfStringItemWidget({
    required this.item,
    super.key,
  });
  final String item;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '• ',
            style: TextStyle(fontSize: 16, color: Colors.black87),
          ),
          Expanded(
            child: Text(
              item,
              style: const TextStyle(fontSize: 16, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}

class PreviewScreen extends StatefulWidget {
  const PreviewScreen({super.key, required this.noResume});
  final VoidCallback noResume;
  @override
  State<PreviewScreen> createState() => _PreviewScreenState();
}

class _PreviewScreenState extends State<PreviewScreen> {
  late Resume? _resume;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _resume = context.watch<ResumeService>().resume;
    if (_resume == null) {
      return Center(
        child: ElevatedButton.icon(
          icon: const Icon(Icons.upload_file),
          onPressed: widget.noResume,
          label: const Text('Add Resume'),
        ),
      );
    }
    return ResumePreview(
      resume: _resume ?? Resume(),
    );
  }
}
