import 'package:flutter/material.dart';
import 'package:itpsm_mobile/core/utils/widgets/vertical_labeled_text.dart';
import 'package:responsive_framework/responsive_framework.dart';

class StudentAcademicInformation extends StatelessWidget {
  const StudentAcademicInformation({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ResponsiveWrapperData responsive = ResponsiveWrapper.of(context);

    return Container(
      margin: const EdgeInsets.all(10),
      child: Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Información académica',
                  style: theme.textTheme.titleSmall,
                ),
              ),
              const SizedBox(height: 20),
              ResponsiveRowColumn(
                rowMainAxisAlignment: MainAxisAlignment.spaceEvenly,
                rowCrossAxisAlignment: CrossAxisAlignment.start,
                rowSpacing: 20,
                columnMainAxisAlignment: MainAxisAlignment.start,
                columnCrossAxisAlignment: CrossAxisAlignment.center,
                columnSpacing: 20,
                layout: responsive.isSmallerThan(DESKTOP) ? 
                ResponsiveRowColumnType.COLUMN : ResponsiveRowColumnType.ROW,
                children: const [
                  ResponsiveRowColumnItem(
                    rowFit: FlexFit.tight,
                    child: VerticalLabeledText(
                      label: 'Plan de estudio', 
                      text: 'Técnico Superior en Hostelería y Turismo'
                    )
                  ),
                  ResponsiveRowColumnItem(
                    rowFit: FlexFit.tight,
                    child: VerticalLabeledText(
                      label: 'Correo institucional', 
                      text: 'janessa67@yahoo.com'
                    )
                  ),
                  ResponsiveRowColumnItem(
                    rowFit: FlexFit.tight,
                    child: VerticalLabeledText(
                      label: 'Año de ingreso', 
                      text: '2022'
                    )
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ResponsiveRowColumn(
                rowMainAxisAlignment: MainAxisAlignment.spaceEvenly,
                rowCrossAxisAlignment: CrossAxisAlignment.start,
                rowSpacing: 20,
                columnMainAxisAlignment: MainAxisAlignment.start,
                columnCrossAxisAlignment: CrossAxisAlignment.center,
                columnSpacing: 20,
                layout: responsive.isSmallerThan(DESKTOP) ? 
                ResponsiveRowColumnType.COLUMN : ResponsiveRowColumnType.ROW,
                children: const [
                  ResponsiveRowColumnItem(
                    rowFit: FlexFit.tight,
                    child: VerticalLabeledText(
                      label: 'CUM', 
                      text: '8.90 (mínimo para egresar: 7.00)'
                    )
                  ),
                  ResponsiveRowColumnItem(
                    rowFit: FlexFit.tight,
                    child: VerticalLabeledText(
                      label: 'Estado', 
                      text: 'En curso'
                    )
                  ),
                  ResponsiveRowColumnItem(
                    rowFit: FlexFit.tight,
                    child: VerticalLabeledText(
                      label: 'UV aprobadas', 
                      text: '4'
                    )
                  ),
                ],
              ),
            ],
          ),
        )
      ),
    );
  }
}