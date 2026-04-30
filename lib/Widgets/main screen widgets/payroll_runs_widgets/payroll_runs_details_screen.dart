import 'package:flutter/material.dart';
import '../../../Controllers/Main screen controllers/payroll_runs_controller.dart';
import 'elements_table_section.dart';
import 'employees_table_section.dart';
import 'information_section.dart';

Widget payrollRunsDetailsScreen({
  required PayrollRunsController controller,
  required BoxConstraints constraints,
  required BuildContext context,
}) {
  return _PayrollRunsDetailsScrollableLayout(
    constraints: constraints,
    screenContext: context,
  );
}

class _PayrollRunsDetailsScrollableLayout extends StatefulWidget {
  const _PayrollRunsDetailsScrollableLayout({
    required this.constraints,
    required this.screenContext,
  });

  final BoxConstraints constraints;
  final BuildContext screenContext;

  @override
  State<_PayrollRunsDetailsScrollableLayout> createState() =>
      _PayrollRunsDetailsScrollableLayoutState();
}

class _PayrollRunsDetailsScrollableLayoutState
    extends State<_PayrollRunsDetailsScrollableLayout> {
  final ScrollController _horizontalController = ScrollController();

  @override
  void dispose() {
    _horizontalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const double gap = 10;
    const double minimumEmployeeWidth = 620;
    const double minimumDetailsWidth = 360;
    const int employeeFlex = 2;
    const int detailsFlex = 1;

    return LayoutBuilder(
      builder: (context, detailsConstraints) {
        final double viewportWidth = detailsConstraints.maxWidth.isFinite
            ? detailsConstraints.maxWidth
            : widget.constraints.maxWidth;
        const double minimumLayoutWidth =
            minimumEmployeeWidth + minimumDetailsWidth + gap;
        final double layoutWidth = viewportWidth < minimumLayoutWidth
            ? minimumLayoutWidth
            : viewportWidth;
        final double extraWidth = layoutWidth - minimumLayoutWidth;
        final double employeeWidth =
            minimumEmployeeWidth +
            (extraWidth * employeeFlex / (employeeFlex + detailsFlex));
        final double detailsWidth = layoutWidth - employeeWidth - gap;
        final bool canScrollHorizontally = layoutWidth > viewportWidth;

        return Scrollbar(
          controller: _horizontalController,
          thumbVisibility: canScrollHorizontally,
          child: SingleChildScrollView(
            controller: _horizontalController,
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: layoutWidth,
              child: Row(
                spacing: gap,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    width: employeeWidth,
                    child: LayoutBuilder(
                      builder: (context, employeeConstraints) {
                        return employeeTableSection(
                          constraints: employeeConstraints,
                          context: widget.screenContext,
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    width: detailsWidth,
                    child: LayoutBuilder(
                      builder: (context, detailsPanelConstraints) {
                        return Column(
                          spacing: 5,
                          children: [
                            Expanded(
                              child: elementsTableSection(
                                constraints: detailsPanelConstraints,
                                context: widget.screenContext,
                              ),
                            ),
                            Expanded(
                              child: informationTableSection(
                                constraints: detailsPanelConstraints,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
