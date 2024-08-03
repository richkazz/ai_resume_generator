import 'package:myapp/models/resume.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class ResumeToPDF {
  Future<void> generatePDF(Resume resume) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        build: (context) => [
          _buildHeader(resume),
          _buildObjective(resume),
          _buildProjects(resume),
          _buildWorkExperience(resume),
          _buildProfile(resume),
          _buildEducation(resume),
          _buildSkills(resume),
          _buildCertifications(resume),
          _buildContactInformation(resume),
          _buildReferee(resume),
        ],
      ),
    );

    // Save the PDF
    await Printing.sharePdf(bytes: await pdf.save(), filename: 'resume.pdf');
  }

  pw.Widget _buildHeader(Resume resume) {
    return pw.Header(
      level: 0,
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(resume.name ?? '',
              style:
                  pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 5),
          pw.Text('${resume.address}\n${resume.email}\n${resume.phoneNumber}'),
        ],
      ),
    );
  }

  pw.Widget _buildObjective(Resume resume) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Header(level: 1, text: 'OBJECTIVE'),
        pw.Text(resume.objective ?? ''),
      ],
    );
  }

  pw.Widget _buildProjects(Resume resume) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Header(level: 1, text: 'PROJECTS'),
        ...resume.projects.map((project) => pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text('Product Name: ${project.name}',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                pw.Text('Technologies: ${project.technologies.join(", ")}'),
                pw.Text('Description: ${project.description}'),
                if (project.keyFeatures.isNotEmpty) ...[
                  pw.Text('Key Features:',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  ...project.keyFeatures.map((e) => pw.Bullet(text: e)),
                ],
                pw.SizedBox(height: 10),
              ],
            )),
      ],
    );
  }

  pw.Widget _buildWorkExperience(Resume resume) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Header(level: 1, text: 'WORK EXPERIENCE'),
        ...resume.workExperience.map((experience) => pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(experience.company ?? '',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                pw.Text('Position: ${experience.position}'),
                ...experience.responsibilities.map((e) => pw.Bullet(text: e)),
                pw.SizedBox(height: 10),
              ],
            )),
      ],
    );
  }

  pw.Widget _buildProfile(Resume resume) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Header(level: 1, text: 'PROFILE'),
        ...(resume.profile?.split('\n').map((s) => s.trim()) ?? [])
            .map((e) => pw.Bullet(text: e)),
      ],
    );
  }

  pw.Widget _buildEducation(Resume resume) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Header(level: 1, text: 'EDUCATION'),
        ...resume.education
            .map((edu) => pw.Text('${edu.institution}\n${edu.degree}')),
      ],
    );
  }

  pw.Widget _buildSkills(Resume resume) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Header(level: 1, text: 'SKILLS'),
        pw.Text(resume.skills.join(', ')),
      ],
    );
  }

  pw.Widget _buildCertifications(Resume resume) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Header(level: 1, text: 'CERTIFICATION'),
        ...resume.certifications.map((cert) => pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                    '${cert.name} - ${cert.organization} ${cert.date?.year}'),
                pw.Text('Verify online: ${cert.verificationLink}'),
                pw.SizedBox(height: 5),
              ],
            )),
      ],
    );
  }

  pw.Widget _buildContactInformation(Resume resume) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Header(level: 1, text: 'CONTACT INFORMATION:'),
        pw.Text('LinkedIn: ${resume.contactInformation?.linkedin}'),
      ],
    );
  }

  pw.Widget _buildReferee(Resume resume) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Header(level: 1, text: 'REFEREE'),
        pw.Text(resume.referee ?? ''),
      ],
    );
  }
}