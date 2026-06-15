import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const BibliotecaApp());
}

const Color azulSenai = Color(0xFF003366);
const Color laranjaSenal = Color(0xFFF39200);
const Color cinzaClaro = Color(0xFFF1F5F9);
const Color cinzaMedio = Color(0xFFE2E8F0);

class Livro {
  String isbn;
  String nome;
  String disciplina;
  String prateleira;
  int quantidade;
  bool selecionado;
  bool reservado;

  Livro({
    required this.isbn,
    required this.nome,
    required this.disciplina,
    required this.prateleira,
    required this.quantidade,
    this.selecionado = false,
    this.reservado = false,
  });
}

class BibliotecaApp extends StatelessWidget {
  const BibliotecaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Biblioteca SENAI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: azulSenai),
        fontFamily: 'Arial',
      ),
      home: const BibliotecaPage(),
    );
  }
}

class BibliotecaPage extends StatefulWidget {
  const BibliotecaPage({super.key});

  @override
  State<BibliotecaPage> createState() => _BibliotecaPageState();
}

class _BibliotecaPageState extends State<BibliotecaPage> {
  final List<Livro> _livros = [
    Livro(isbn: '978-85-1234-567-8', nome: 'Dom Casmurro', disciplina: 'Português', prateleira: 'A1', quantidade: 5),
    Livro(isbn: '978-85-9876-543-2', nome: 'O Alquimista', disciplina: 'Literatura', prateleira: 'B3', quantidade: 3),
    Livro(isbn: '978-85-5678-901-2', nome: '1984', disciplina: 'Literatura', prateleira: 'C2', quantidade: 2),
    Livro(isbn: '978-85-4321-876-5', nome: 'Senhor dos Anéis', disciplina: 'Literatura', prateleira: 'D5', quantidade: 4),
    Livro(isbn: '978-85-2468-135-7', nome: 'Python para Todos', disciplina: 'Programação', prateleira: 'E1', quantidade: 7),
    Livro(isbn: '978-85-3698-741-2', nome: 'Redes de Computadores', disciplina: 'Redes', prateleira: 'F4', quantidade: 2),
  ];

  int get _qtdSelecionados => _livros.where((l) => l.selecionado).length;

  void _toggleSelecao(int index) {
    setState(() => _livros[index].selecionado = !_livros[index].selecionado);
  }

  void _excluirLivro(int index) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Confirmar exclusão'),
        content: Text('Deseja excluir "${_livros[index].nome}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              setState(() => _livros.removeAt(index));
              Navigator.pop(context);
            },
            child: const Text('Excluir', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _abrirFormulario({int? index}) {
    final livroExistente = index != null ? _livros[index] : null;

    showDialog<Livro>(
      context: context,
      builder: (_) => LivroFormDialog(livro: livroExistente),
    ).then((livroSalvo) {
      if (livroSalvo == null) return;
      setState(() {
        if (index != null) {
          _livros[index] = livroSalvo;
        } else {
          _livros.add(livroSalvo);
        }
      });
    });
  }

  void _reservarSelecionados() {
    if (_qtdSelecionados == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pressione e segure ao menos um livro para selecioná-lo')),
      );
      return;
    }
    setState(() {
      for (final livro in _livros) {
        if (livro.selecionado) {
          livro.reservado = true;
          livro.selecionado = false;
        }
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Livros reservados com sucesso!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _abrirReservas() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ReservasPage(livros: _livros)),
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cinzaClaro,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildPageHeader(),
          Expanded(child: _buildListaLivros()),
          _buildDica(),
          _buildActionBar(),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: azulSenai,
      elevation: 4,
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Text(
              'SENAI',
              style: TextStyle(color: azulSenai, fontWeight: FontWeight.bold, fontSize: 13),
            ),
          ),
          const SizedBox(width: 8),
          const Text('SENAI', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.menu_book, color: laranjaSenal),
          tooltip: 'Biblioteca',
        ),
        IconButton(
          onPressed: _abrirReservas,
          icon: const Icon(Icons.calendar_today, color: Colors.white70),
          tooltip: 'Reservas',
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.logout, color: Colors.white70),
          tooltip: 'Sair',
        ),
      ],
    );
  }

  Widget _buildPageHeader() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Row(
            children: [
              Icon(Icons.menu_book, color: azulSenai, size: 20),
              SizedBox(width: 8),
              Text(
                'Biblioteca SENAI',
                style: TextStyle(color: azulSenai, fontSize: 16, fontWeight: FontWeight.w700),
              ),
            ],
          ),
          ElevatedButton.icon(
            onPressed: () => _abrirFormulario(),
            icon: const Icon(Icons.add_circle, size: 16),
            label: const Text('Adicionar'),
            style: ElevatedButton.styleFrom(
              backgroundColor: laranjaSenal,
              foregroundColor: Colors.white,
              textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListaLivros() {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: _livros.length,
      itemBuilder: (context, index) => _buildCardLivro(index),
    );
  }

  Widget _buildCardLivro(int index) {
    final livro = _livros[index];

    return GestureDetector(
      onLongPress: () => _toggleSelecao(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: livro.selecionado
              ? const Color(0xFFFFF3E0)
              : livro.reservado
                  ? const Color(0xFFE8F5E9)
                  : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: livro.selecionado
                ? laranjaSenal
                : livro.reservado
                    ? Colors.green
                    : cinzaMedio,
            width: (livro.selecionado || livro.reservado) ? 2 : 1,
          ),
          boxShadow: const [BoxShadow(color: Color(0x0D000000), blurRadius: 8, offset: Offset(0, 2))],
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: azulSenai.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      livro.selecionado
                          ? Icons.check_circle
                          : livro.reservado
                              ? Icons.bookmark
                              : Icons.menu_book,
                      color: livro.selecionado
                          ? laranjaSenal
                          : livro.reservado
                              ? Colors.green
                              : azulSenai,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          livro.nome,
                          style: const TextStyle(
                            color: Color(0xFF2D3748),
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          livro.isbn,
                          style: const TextStyle(color: Color(0xFF718096), fontSize: 11),
                        ),
                        if (livro.reservado)
                          const Text(
                            'Reservado',
                            style: TextStyle(color: Colors.green, fontSize: 11, fontWeight: FontWeight.w600),
                          ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _ActionButton(
                        icon: Icons.edit,
                        color: azulSenai,
                        onPressed: () => _abrirFormulario(index: index),
                      ),
                      _ActionButton(
                        icon: Icons.delete,
                        color: const Color(0xFFC53030),
                        onPressed: () => _excluirLivro(index),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Divider(height: 1, color: Color(0xFFEDF2F7)),
              const SizedBox(height: 10),
              Row(
                children: [
                  _InfoChip(label: 'Disciplina', value: livro.disciplina),
                  const SizedBox(width: 8),
                  _InfoChip(label: 'Prateleira', value: livro.prateleira),
                  const SizedBox(width: 8),
                  _InfoChip(label: 'Qtd.', value: '${livro.quantidade}'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDica() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: cinzaMedio,
        borderRadius: BorderRadius.circular(8),
        border: const Border(left: BorderSide(color: laranjaSenal, width: 4)),
      ),
      child: const Row(
        children: [
          Icon(Icons.lightbulb, color: laranjaSenal, size: 18),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              'Dica: Pressione e segure qualquer card para selecionar o livro',
              style: TextStyle(color: Color(0xFF2D3748), fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionBar() {
    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: cinzaMedio),
        boxShadow: const [BoxShadow(color: Color(0x0D000000), blurRadius: 8, offset: Offset(0, 2))],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton.icon(
            onPressed: _reservarSelecionados,
            icon: const Icon(Icons.bookmark, size: 16),
            label: const Text('Reservar'),
            style: ElevatedButton.styleFrom(
              backgroundColor: azulSenai,
              foregroundColor: Colors.white,
              textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
          Row(
            children: [
              Icon(
                _qtdSelecionados > 0 ? Icons.check_circle : Icons.check_circle_outline,
                color: _qtdSelecionados > 0 ? laranjaSenal : const Color(0xFF718096),
                size: 16,
              ),
              const SizedBox(width: 6),
              Text(
                '$_qtdSelecionados selecionado(s)',
                style: const TextStyle(color: Color(0xFF718096), fontSize: 12, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Dialog de Formulário (Adicionar / Editar) ─────────────────────────────────

class LivroFormDialog extends StatefulWidget {
  final Livro? livro;
  const LivroFormDialog({super.key, this.livro});

  @override
  State<LivroFormDialog> createState() => _LivroFormDialogState();
}

class _LivroFormDialogState extends State<LivroFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _isbnCtrl;
  late final TextEditingController _nomeCtrl;
  late final TextEditingController _disciplinaCtrl;
  late final TextEditingController _prateleiraCtrl;
  late final TextEditingController _quantidadeCtrl;

  bool get _isEditing => widget.livro != null;

  @override
  void initState() {
    super.initState();
    _isbnCtrl = TextEditingController(text: widget.livro?.isbn ?? '');
    _nomeCtrl = TextEditingController(text: widget.livro?.nome ?? '');
    _disciplinaCtrl = TextEditingController(text: widget.livro?.disciplina ?? '');
    _prateleiraCtrl = TextEditingController(text: widget.livro?.prateleira ?? '');
    _quantidadeCtrl = TextEditingController(text: widget.livro != null ? '${widget.livro!.quantidade}' : '');
  }

  @override
  void dispose() {
    _isbnCtrl.dispose();
    _nomeCtrl.dispose();
    _disciplinaCtrl.dispose();
    _prateleiraCtrl.dispose();
    _quantidadeCtrl.dispose();
    super.dispose();
  }

  void _salvar() {
    if (!_formKey.currentState!.validate()) return;
    final livro = Livro(
      isbn: _isbnCtrl.text.trim(),
      nome: _nomeCtrl.text.trim(),
      disciplina: _disciplinaCtrl.text.trim(),
      prateleira: _prateleiraCtrl.text.trim(),
      quantidade: int.parse(_quantidadeCtrl.text.trim()),
      reservado: widget.livro?.reservado ?? false,
    );
    Navigator.pop(context, livro);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Row(
        children: [
          Icon(_isEditing ? Icons.edit : Icons.add_circle, color: azulSenai, size: 22),
          const SizedBox(width: 8),
          Text(
            _isEditing ? 'Editar Livro' : 'Adicionar Livro',
            style: const TextStyle(color: azulSenai, fontSize: 17, fontWeight: FontWeight.w700),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildField('ISBN', _isbnCtrl, hint: '978-85-0000-000-0'),
              const SizedBox(height: 12),
              _buildField('Nome do Livro', _nomeCtrl, hint: 'Ex: Dom Casmurro'),
              const SizedBox(height: 12),
              _buildField('Disciplina', _disciplinaCtrl, hint: 'Ex: Literatura'),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: _buildField('Prateleira', _prateleiraCtrl, hint: 'A1')),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildField(
                      'Qtd.',
                      _quantidadeCtrl,
                      hint: '1',
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar', style: TextStyle(color: Color(0xFF718096))),
        ),
        ElevatedButton(
          onPressed: _salvar,
          style: ElevatedButton.styleFrom(
            backgroundColor: azulSenai,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          child: Text(_isEditing ? 'Salvar' : 'Adicionar'),
        ),
      ],
    );
  }

  Widget _buildField(
    String label,
    TextEditingController controller, {
    String? hint,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        labelStyle: const TextStyle(color: Color(0xFF718096), fontSize: 13),
        filled: true,
        fillColor: cinzaClaro,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: cinzaMedio),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: cinzaMedio),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: azulSenai, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.red),
        ),
      ),
      validator: (val) => (val == null || val.trim().isEmpty) ? 'Obrigatório' : null,
    );
  }
}

// ── Tela de Reservas ──────────────────────────────────────────────────────────

class ReservasPage extends StatefulWidget {
  final List<Livro> livros;
  const ReservasPage({super.key, required this.livros});

  @override
  State<ReservasPage> createState() => _ReservasPageState();
}

class _ReservasPageState extends State<ReservasPage> {
  List<Livro> get _reservados => widget.livros.where((l) => l.reservado).toList();

  void _cancelarReserva(Livro livro) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Cancelar reserva'),
        content: Text('Deseja cancelar a reserva de "${livro.nome}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Não'),
          ),
          TextButton(
            onPressed: () {
              setState(() => livro.reservado = false);
              Navigator.pop(context);
            },
            child: const Text('Sim', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final reservados = _reservados;

    return Scaffold(
      backgroundColor: cinzaClaro,
      appBar: AppBar(
        backgroundColor: azulSenai,
        foregroundColor: Colors.white,
        title: const Row(
          children: [
            Icon(Icons.bookmark, color: laranjaSenal),
            SizedBox(width: 8),
            Text('Minhas Reservas', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
      body: reservados.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.bookmark_border, size: 64, color: Color(0xFFCBD5E0)),
                  SizedBox(height: 16),
                  Text('Nenhuma reserva ativa', style: TextStyle(color: Color(0xFF718096), fontSize: 16)),
                  SizedBox(height: 8),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 32),
                    child: Text(
                      'Selecione livros na biblioteca e toque em "Reservar"',
                      style: TextStyle(color: Color(0xFFA0AEC0), fontSize: 13),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: reservados.length,
              itemBuilder: (context, index) {
                final livro = reservados[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.green.shade200),
                    boxShadow: const [BoxShadow(color: Color(0x0D000000), blurRadius: 8, offset: Offset(0, 2))],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.green.shade50,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.bookmark, color: Colors.green, size: 22),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                livro.nome,
                                style: const TextStyle(
                                  color: Color(0xFF2D3748),
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(livro.disciplina, style: const TextStyle(color: Color(0xFF718096), fontSize: 12)),
                              Text(livro.isbn, style: const TextStyle(color: Color(0xFFA0AEC0), fontSize: 11)),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () => _cancelarReserva(livro),
                          icon: const Icon(Icons.cancel, color: Color(0xFFC53030)),
                          tooltip: 'Cancelar reserva',
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}

// ── Widgets auxiliares ────────────────────────────────────────────────────────

class _InfoChip extends StatelessWidget {
  final String label;
  final String value;
  const _InfoChip({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: cinzaClaro,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: cinzaMedio),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(color: Color(0xFF718096), fontSize: 10)),
            Text(
              value,
              style: const TextStyle(color: Color(0xFF2D3748), fontSize: 12, fontWeight: FontWeight.w600),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;

  const _ActionButton({required this.icon, required this.color, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(icon, color: color, size: 20),
      padding: const EdgeInsets.all(6),
      constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
    );
  }
}
