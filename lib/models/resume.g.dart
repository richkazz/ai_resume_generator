// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'resume.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ResumeAdapter extends TypeAdapter<Resume> {
  @override
  final int typeId = 0;

  @override
  Resume read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Resume(
      name: fields[0] as String?,
      address: fields[1] as String?,
      phoneNumber: fields[2] as String?,
      email: fields[3] as String?,
      objective: fields[4] as String?,
      skills: (fields[5] as List).cast<String>(),
      workExperience: (fields[6] as List).cast<WorkExperience>(),
      education: (fields[7] as List).cast<Education>(),
      projects: (fields[8] as List).cast<Project>(),
      profile: fields[9] as String?,
      certifications: (fields[10] as List).cast<Certification>(),
      contactInformation: fields[11] as ContactInformation?,
      referee: fields[12] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Resume obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.address)
      ..writeByte(2)
      ..write(obj.phoneNumber)
      ..writeByte(3)
      ..write(obj.email)
      ..writeByte(4)
      ..write(obj.objective)
      ..writeByte(5)
      ..write(obj.skills)
      ..writeByte(6)
      ..write(obj.workExperience)
      ..writeByte(7)
      ..write(obj.education)
      ..writeByte(8)
      ..write(obj.projects)
      ..writeByte(9)
      ..write(obj.profile)
      ..writeByte(10)
      ..write(obj.certifications)
      ..writeByte(11)
      ..write(obj.contactInformation)
      ..writeByte(12)
      ..write(obj.referee);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ResumeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class WorkExperienceAdapter extends TypeAdapter<WorkExperience> {
  @override
  final int typeId = 1;

  @override
  WorkExperience read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WorkExperience(
      company: fields[0] as String?,
      position: fields[1] as String?,
      startDate: fields[2] as DateTime?,
      endDate: fields[3] as DateTime?,
      responsibilities: (fields[4] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, WorkExperience obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.company)
      ..writeByte(1)
      ..write(obj.position)
      ..writeByte(2)
      ..write(obj.startDate)
      ..writeByte(3)
      ..write(obj.endDate)
      ..writeByte(4)
      ..write(obj.responsibilities);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WorkExperienceAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class EducationAdapter extends TypeAdapter<Education> {
  @override
  final int typeId = 2;

  @override
  Education read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Education(
      institution: fields[0] as String?,
      degree: fields[1] as String?,
      graduationDate: fields[2] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, Education obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.institution)
      ..writeByte(1)
      ..write(obj.degree)
      ..writeByte(2)
      ..write(obj.graduationDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EducationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ProjectAdapter extends TypeAdapter<Project> {
  @override
  final int typeId = 3;

  @override
  Project read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Project(
      name: fields[0] as String?,
      technologies: (fields[1] as List).cast<String>(),
      description: fields[2] as String?,
      keyFeatures: (fields[3] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, Project obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.technologies)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.keyFeatures);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProjectAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CertificationAdapter extends TypeAdapter<Certification> {
  @override
  final int typeId = 4;

  @override
  Certification read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Certification(
      name: fields[0] as String?,
      organization: fields[1] as String?,
      date: fields[2] as DateTime?,
      verificationLink: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Certification obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.organization)
      ..writeByte(2)
      ..write(obj.date)
      ..writeByte(3)
      ..write(obj.verificationLink);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CertificationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ContactInformationAdapter extends TypeAdapter<ContactInformation> {
  @override
  final int typeId = 5;

  @override
  ContactInformation read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ContactInformation(
      linkedin: fields[0] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ContactInformation obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.linkedin);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ContactInformationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
