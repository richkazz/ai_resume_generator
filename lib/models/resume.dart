import 'dart:convert';
import 'package:hive/hive.dart';

part 'resume.g.dart';

@HiveType(typeId: 0)
class Resume extends HiveObject {
  @HiveField(0)
  String? name;
  @HiveField(1)
  String? address;
  @HiveField(2)
  String? phoneNumber;
  @HiveField(3)
  String? email;
  @HiveField(4)
  String? objective;
  @HiveField(5)
  List<String> skills;
  @HiveField(6)
  List<WorkExperience> workExperience;
  @HiveField(7)
  List<Education> education;
  @HiveField(8)
  List<Project> projects;
  @HiveField(9)
  String? profile;
  @HiveField(10)
  List<Certification> certifications;
  @HiveField(11)
  ContactInformation? contactInformation;
  @HiveField(12)
  String? referee;

  Resume({
    this.name,
    this.address,
    this.phoneNumber,
    this.email,
    this.objective,
    this.skills = const [],
    this.workExperience = const [],
    this.education = const [],
    this.projects = const [],
    this.profile,
    this.certifications = const [],
    this.contactInformation,
    this.referee,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'address': address,
      'phoneNumber': phoneNumber,
      'email': email,
      'objective': objective,
      'skills': skills,
      'workExperience': workExperience.map((e) => e.toJson()).toList(),
      'education': education.map((e) => e.toJson()).toList(),
      'projects': projects.map((e) => e.toJson()).toList(),
      'profile': profile,
      'certifications': certifications.map((e) => e.toJson()).toList(),
      'contactInformation': contactInformation?.toJson(),
      'referee': referee,
    };
  }

  factory Resume.fromJson(String source) => Resume.fromMap(json.decode(source));

  factory Resume.fromMap(Map<String, dynamic> map) {
    return Resume(
      name: map['name'],
      address: map['address'],
      phoneNumber: map['phoneNumber'],
      email: map['email'],
      objective: map['objective'],
      skills: List<String>.from(map['skills'] ?? []),
      workExperience: List<WorkExperience>.from(
          (map['workExperience'] ?? []).map((x) => WorkExperience.fromMap(x))),
      education: List<Education>.from(
          (map['education'] ?? []).map((x) => Education.fromMap(x))),
      projects: List<Project>.from(
          (map['projects'] ?? []).map((x) => Project.fromMap(x))),
      profile: map['profile'],
      certifications: List<Certification>.from(
          (map['certifications'] ?? []).map((x) => Certification.fromMap(x))),
      contactInformation: map['contactInformation'] != null
          ? ContactInformation.fromMap(map['contactInformation'])
          : null,
      referee: map['referee'],
    );
  }
}

@HiveType(typeId: 1)
class WorkExperience extends HiveObject {
  @HiveField(0)
  String? company;
  @HiveField(1)
  String? position;
  @HiveField(2)
  DateTime? startDate;
  @HiveField(3)
  DateTime? endDate;
  @HiveField(4)
  List<String> responsibilities;

  WorkExperience({
    this.company,
    this.position,
    this.startDate,
    this.endDate,
    this.responsibilities = const [],
  });

  Map<String, dynamic> toJson() {
    return {
      'company': company,
      'position': position,
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'responsibilities': responsibilities,
    };
  }

  factory WorkExperience.fromJson(Map<String, dynamic> json) =>
      WorkExperience.fromMap(json);

  factory WorkExperience.fromMap(Map<String, dynamic> map) {
    return WorkExperience(
      company: map['company'],
      position: map['position'],
      startDate:
          map['startDate'] != null ? DateTime.parse(map['startDate']) : null,
      endDate: map['endDate'] != null ? DateTime.parse(map['endDate']) : null,
      responsibilities: List<String>.from(map['responsibilities'] ?? []),
    );
  }
}

@HiveType(typeId: 2)
class Education extends HiveObject {
  @HiveField(0)
  String? institution;
  @HiveField(1)
  String? degree;
  @HiveField(2)
  DateTime? graduationDate;

  Education({
    this.institution,
    this.degree,
    this.graduationDate,
  });

  Map<String, dynamic> toJson() {
    return {
      'institution': institution,
      'degree': degree,
      'graduationDate': graduationDate?.toIso8601String(),
    };
  }

  factory Education.fromJson(Map<String, dynamic> json) =>
      Education.fromMap(json);

  factory Education.fromMap(Map<String, dynamic> map) {
    return Education(
      institution: map['institution'],
      degree: map['degree'],
      graduationDate: map['graduationDate'] != null
          ? DateTime.parse(map['graduationDate'])
          : null,
    );
  }
}

@HiveType(typeId: 3)
class Project extends HiveObject {
  @HiveField(0)
  String? name;
  @HiveField(1)
  List<String> technologies;
  @HiveField(2)
  String? description;
  @HiveField(3)
  List<String> keyFeatures;

  Project({
    this.name,
    this.technologies = const [],
    this.description,
    this.keyFeatures = const [],
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'technologies': technologies,
      'description': description,
      'keyFeatures': keyFeatures,
    };
  }

  factory Project.fromJson(Map<String, dynamic> json) => Project.fromMap(json);

  factory Project.fromMap(Map<String, dynamic> map) {
    return Project(
      name: map['name'],
      technologies: List<String>.from(map['technologies'] ?? []),
      description: map['description'],
      keyFeatures: List<String>.from(map['keyFeatures'] ?? []),
    );
  }
}

@HiveType(typeId: 4)
class Certification extends HiveObject {
  @HiveField(0)
  String? name;
  @HiveField(1)
  String? organization;
  @HiveField(2)
  DateTime? date;
  @HiveField(3)
  String? verificationLink;

  Certification({
    this.name,
    this.organization,
    this.date,
    this.verificationLink,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'organization': organization,
      'date': date?.toIso8601String(),
      'verificationLink': verificationLink,
    };
  }

  factory Certification.fromJson(Map<String, dynamic> json) =>
      Certification.fromMap(json);

  factory Certification.fromMap(Map<String, dynamic> map) {
    return Certification(
      name: map['name'],
      organization: map['organization'],
      date: map['date'] != null ? DateTime.parse(map['date']) : null,
      verificationLink: map['verificationLink'],
    );
  }
}

@HiveType(typeId: 5)
class ContactInformation extends HiveObject {
  @HiveField(0)
  String? linkedin;

  ContactInformation({
    this.linkedin,
  });

  Map<String, dynamic> toJson() {
    return {
      'linkedin': linkedin,
    };
  }

  factory ContactInformation.fromJson(Map<String, dynamic> json) =>
      ContactInformation.fromMap(json);

  factory ContactInformation.fromMap(Map<String, dynamic> map) {
    return ContactInformation(
      linkedin: map['linkedin'],
    );
  }
}
