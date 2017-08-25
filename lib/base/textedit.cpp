
#ifndef QT_NO_PRINTER
#ifdef QT50
#include <QtPrintSupport/QPrinter>
#else
#include <QPrinter>
#endif
#endif
#include <QUrl>

#include "textedit.h"
#include "dialog.h"
#include "state.h"

// ---------------------------------------------------------------------
TextEdit::TextEdit(QWidget *parent) : QTextEdit(parent)
{
  setAcceptRichText(false);
  blockfmt=textCursor().blockFormat();
  charfmt=textCursor().charFormat();
#ifdef QT53
  document()->setBaseUrl(currenturl());
#else
  document()->setMetaInformation(QTextDocument::DocumentUrl, currenturl().toString());
#endif
  document()->setDocumentMargin(0);
  connect(this, SIGNAL(cursorPositionChanged()), this, SLOT(highlightCurrentLine()));
  highlightCurrentLine();
}

// ---------------------------------------------------------------------
void TextEdit::appendHtml(const QString &text)
{
  newblock();
  insertHtml(text);
}

// ---------------------------------------------------------------------
void TextEdit::appendPlainText(const QString &text)
{
  newblock();
  insertPlainText(text);
}

// ---------------------------------------------------------------------
QTextBlock TextEdit::firstVisibleBlock()
{
  return cursorForPosition(QPoint(0,0)).block();
}

// ---------------------------------------------------------------------
void TextEdit::highlightCurrentLine()
{
  QList<QTextEdit::ExtraSelection> extraSelections;
  QTextEdit::ExtraSelection selection;
  QColor lineColor = (type==0)?config.TermHigh.color:config.EditHigh.color;
  selection.format.setBackground(lineColor);
  selection.format.setProperty(QTextFormat::FullWidthSelection, true);
  selection.cursor = textCursor();
  selection.cursor.clearSelection();
  extraSelections.append(selection);
  setExtraSelections(extraSelections);
}

// ---------------------------------------------------------------------
void TextEdit::home()
{
  QString ws=" \t";
  QTextCursor c = textCursor();
  QString txt = c.block().text();
  int pos=getpositioninblock(c);
  txt = txt.left(pos);
  int mov=0;
  for (int i=0; i<pos; i++)
    if (!ws.contains(txt.at(i))) {
      mov=i;
      break;
    }
  c.setPosition(c.position()-pos+mov);
  setTextCursor(c);
}

// ---------------------------------------------------------------------
void TextEdit::homeshift()
{
  QString ws=" \t";
  QTextCursor c = textCursor();
  QString txt = c.block().text();
  int pos=getpositioninblock(c);
  txt = txt.left(pos);
  int mov=0;
  for (int i=0; i<pos; i++)
    if (!ws.contains(txt.at(i))) {
      mov=i;
      break;
    }
  int cur=c.position();
  setselect(cur-pos+mov,pos-mov);
}

// ---------------------------------------------------------------------
void TextEdit::newblock()
{
  if (toPlainText().length() > 0) {
    QTextCursor c = textCursor();
    c.movePosition(QTextCursor::End);
    c.insertBlock(blockfmt,charfmt);
  }
}

#ifndef QT_NO_PRINTER
// ---------------------------------------------------------------------
void TextEdit::printPreview(QPrinter *printer)
{
  printpreview(printer,document());
}
#endif

// ---------------------------------------------------------------------
int TextEdit::readcurpos()
{
  return textCursor().position();
}

// ---------------------------------------------------------------------
QString TextEdit::readselected()
{
  QString s=textCursor().selectedText();
  s.replace(0x2029,'\n');
  return s;
}

// ---------------------------------------------------------------------
int TextEdit::readtop()
{
  return qMax(0,firstVisibleBlock().blockNumber());
}

// ---------------------------------------------------------------------
void TextEdit::setcurpos(int pos)
{
  QTextCursor c=textCursor();
  c.setPosition(pos);
  setTextCursor(c);
}

// ---------------------------------------------------------------------
void TextEdit::setselect(int p, int len)
{
  QTextCursor c = textCursor();
  c.setPosition(p+len,QTextCursor::MoveAnchor);
  c.setPosition(p,QTextCursor::KeepAnchor);
  setTextCursor(c);
}

