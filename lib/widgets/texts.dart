import 'package:flutter/material.dart';

class LabelText extends StatelessWidget {
  const LabelText(this.text, {super.key, this.textAlign});
  final String text;
  final TextAlign? textAlign;
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      style: Theme.of(context)
          .textTheme
          .labelMedium!
          .copyWith(fontSize: 16, fontWeight: FontWeight.w400),
    );
  }
}

class LabelTextBold extends StatelessWidget {
  const LabelTextBold(
    this.text, {
    super.key,
  });
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context)
          .textTheme
          .labelMedium!
          .copyWith(fontSize: 16, fontWeight: FontWeight.w700),
    );
  }
}

class BodyText extends StatelessWidget {
  const BodyText(
    this.text, {
    super.key,
    this.textAlign,
    this.fontSize = 14,
    this.fontWeight,
  });
  final String text;
  final TextAlign? textAlign;
  final FontWeight? fontWeight;
  final double fontSize;
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      style: Theme.of(context).textTheme.bodySmall!.copyWith(
            fontSize: fontSize,
            fontWeight: fontWeight,
          ),
    );
  }
}

class BodySmallText extends StatelessWidget {
  const BodySmallText(this.text, {super.key, this.color});
  final String text;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context)
          .textTheme
          .bodySmall!
          .copyWith(fontSize: 12, color: color),
    );
  }
}

class TitleText extends StatelessWidget {
  const TitleText(this.text, {super.key, this.color});
  final String text;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context)
          .textTheme
          .titleMedium!
          .copyWith(fontSize: 20, fontWeight: FontWeight.w700, color: color),
    );
  }
}

class HeaderText extends StatelessWidget {
  const HeaderText(this.text, {super.key, this.textAlign});
  final TextAlign? textAlign;
  final String text;
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      style: Theme.of(context).textTheme.titleLarge!.copyWith(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: Theme.of(context).colorScheme.primary,
          ),
    );
  }
}
