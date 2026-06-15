import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const BibliotecaApp());
}

const Color azulSenai = Color(0xFF003366);
const Color laranjaSenal = Color(0xFFF39200);
const Color cinzaClaro = Color(0xFFF1F5F9);
const Color cinzaMedio = Color(0xFFE2E8F0);

// ── Models ─────────────────────────────────────────────────────────────────────

class Livro {
  String isbn;
  String nome;
  String disciplina;
  String prateleira;
  int quantidade;

  Livro({
    required this.isbn,
    required this.nome,
    required this.disciplina,
    required this.prateleira,
    required this.quantidade,
  });
}

class Usuario {
  String id;
  String nome;
  String email;
  String matricula;
  String telefone;

  Usuario({
    required this.id,
    required this.nome,
    required this.email,
    required this.matricula,
    required this.telefone,
  });
}

class Reserva {
  String id;
  Livro livro;
  Usuario usuario;
  DateTime dataReserva;
  DateTime dataDevolucao;
  String status; // 'ativa' | 'devolvida' | 'cancelada'

  Reserva({
    required this.id,
    required this.livro,
    required this.usuario,
    required this.dataReserva,
    required this.dataDevolucao,
    this.status = 'ativa',
  });
}

// ── App ────────────────────────────────────────────────────────────────────────

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
      home: const HomeScreen(),
    );
  }
}

// ── HomeScreen ─────────────────────────────────────────────────────────────────

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Livro> _livros = [
    Livro(isbn: '978-85-1234-567-8', nome: 'Dom Casmurro', disciplina: 'Português', prateleira: 'A1', quantidade: 5),
    Livro(isbn: '978-85-9876-543-2', nome: 'O Alquimista', disciplina: 'Literatura', prateleira: 'B3', quantidade: 3),
    Livro(isbn: '978-85-5678-901-2', nome: '1984', disciplina: 'Literatura', prateleira: 'C2', quantidade: 2),
    Livro(isbn: '978-85-4321-876-5', nome: 'Senhor dos Anéis', disciplina: 'Literatura', prateleira: 'D5', quantidade: 4),
    Livro(isbn: '978-85-2468-135-7', nome: 'Python para Todos', disciplina: 'Programação', prateleira: 'E1', quantidade: 7),
    Livro(isbn: '978-85-3698-741-2', nome: 'Redes de Computadores', disciplina: 'Redes', prateleira: 'F4', quantidade: 2),
  ];

  final List<Usuario> _usuarios = [
    Usuario(id: '1', nome: 'Ana Silva', email: 'ana@senai.com', matricula: '2024001', telefone: '(11) 99999-0001'),
    Usuario(id: '2', nome: 'Bruno Costa', email: 'bruno@senai.com', matricula: '2024002', telefone: '(11) 99999-0002'),
    Usuario(id: '3', nome: 'Carla Mendes', email: 'carla@senai.com', matricula: '2024003', telefone: '(11) 99999-0003'),
  ];

  final List<Reserva> _reservas = [];

  void _refresh() => setState(() {});

  static const _labels = ['Livros', 'Usuários', 'Reservas'];
  static const _icons = [Icons.menu_book, Icons.people, Icons.bookmark];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cinzaClaro,
      appBar: AppBar(
        backgroundColor: azulSenai,
        elevation: 4,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4)),
              child: const Text(
                'SENAI',
                style: TextStyle(color: azulSenai, fontWeight: FontWeight.bold, fontSize: 13),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'Biblioteca · ${_labels[_currentIndex]}',
              style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          LivrosPage(livros: _livros, onUpdate: _refresh),
          UsuariosPage(usuarios: _usuarios, onUpdate: _refresh),
          ReservasPage(
            livros: _livros,
            usuarios: _usuarios,
            reservas: _reservas,
            onUpdate: _refresh,
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: azulSenai,
        unselectedItemColor: const Color(0xFF718096),
        backgroundColor: Colors.white,
        elevation: 8,
        type: BottomNavigationBarType.fixed,
        onTap: (i) => setState(() => _currentIndex = i),
        items: List.generate(
          3,
          (i) => BottomNavigationBarItem(icon: Icon(_icons[i]), label: _labels[i]),
        ),
      ),
    );
  }
}

// ── LivrosPage ─────────────────────────────────────────────────────────────────

class LivrosPage extends StatefulWidget {
  final List<Livro> livros;
  final VoidCallback onUpdate;

  const LivrosPage({super.key, required this.livros, required this.onUpdate});

  @override
  State<LivrosPage> createState() => _LivrosPageState();
}

class _LivrosPageState extends State<LivrosPage> {
  void _abrirFormulario({int? index}) {
    final livroExistente = index != null ? widget.livros[index] : null;
    showDialog<Livro>(
      context: context,
      builder: (_) => LivroFormDialog(livro: livroExistente),
    ).then((livroSalvo) {
      if (livroSalvo == null) return;
      if (index != null) {
        widget.livros[index] = livroSalvo;
      } else {
        widget.livros.add(livroSalvo);
      }
      widget.onUpdate();
    });
  }

  void _excluirLivro(int index) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Confirmar exclusão'),
        content: Text('Deseja excluir "${widget.livros[index].nome}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          TextButton(
            onPressed: () {
              widget.livros.removeAt(index);
              widget.onUpdate();
              Navigator.pop(context);
            },
            child: const Text('Excluir', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeader(),
        Expanded(
          child: widget.livros.isEmpty
              ? const _EmptyState(icon: Icons.menu_book_outlined, message: 'Nenhum livro cadastrado')
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: widget.livros.length,
                  itemBuilder: (_, i) => _buildCard(i),
                ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '${widget.livros.length} livro(s) cadastrado(s)',
            style: const TextStyle(color: Color(0xFF718096), fontSize: 13),
          ),
          ElevatedButton.icon(
            onPressed: () => _abrirFormulario(),
            icon: const Icon(Icons.add, size: 16),
            label: const Text('Adicionar'),
            style: _btnStyle(laranjaSenal),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(int index) {
    final livro = widget.livros[index];
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cinzaMedio),
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
                  child: const Icon(Icons.menu_book, color: azulSenai, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        livro.nome,
                        style: const TextStyle(color: Color(0xFF2D3748), fontSize: 15, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 2),
                      Text(livro.isbn, style: const TextStyle(color: Color(0xFF718096), fontSize: 11)),
                    ],
                  ),
                ),
                _ActionButton(icon: Icons.edit, color: azulSenai, onPressed: () => _abrirFormulario(index: index)),
                _ActionButton(
                  icon: Icons.delete,
                  color: const Color(0xFFC53030),
                  onPressed: () => _excluirLivro(index),
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
    );
  }
}

// ── UsuariosPage ───────────────────────────────────────────────────────────────

class UsuariosPage extends StatefulWidget {
  final List<Usuario> usuarios;
  final VoidCallback onUpdate;

  const UsuariosPage({super.key, required this.usuarios, required this.onUpdate});

  @override
  State<UsuariosPage> createState() => _UsuariosPageState();
}

class _UsuariosPageState extends State<UsuariosPage> {
  void _abrirFormulario({int? index}) {
    final usuarioExistente = index != null ? widget.usuarios[index] : null;
    showDialog<Usuario>(
      context: context,
      builder: (_) => UsuarioFormDialog(usuario: usuarioExistente),
    ).then((usuarioSalvo) {
      if (usuarioSalvo == null) return;
      if (index != null) {
        widget.usuarios[index] = usuarioSalvo;
      } else {
        widget.usuarios.add(usuarioSalvo);
      }
      widget.onUpdate();
    });
  }

  void _excluirUsuario(int index) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Confirmar exclusão'),
        content: Text('Deseja excluir "${widget.usuarios[index].nome}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          TextButton(
            onPressed: () {
              widget.usuarios.removeAt(index);
              widget.onUpdate();
              Navigator.pop(context);
            },
            child: const Text('Excluir', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeader(),
        Expanded(
          child: widget.usuarios.isEmpty
              ? const _EmptyState(icon: Icons.people_outline, message: 'Nenhum usuário cadastrado')
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: widget.usuarios.length,
                  itemBuilder: (_, i) => _buildCard(i),
                ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '${widget.usuarios.length} usuário(s) cadastrado(s)',
            style: const TextStyle(color: Color(0xFF718096), fontSize: 13),
          ),
          ElevatedButton.icon(
            onPressed: () => _abrirFormulario(),
            icon: const Icon(Icons.add, size: 16),
            label: const Text('Adicionar'),
            style: _btnStyle(laranjaSenal),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(int index) {
    final usuario = widget.usuarios[index];
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cinzaMedio),
        boxShadow: const [BoxShadow(color: Color(0x0D000000), blurRadius: 8, offset: Offset(0, 2))],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            CircleAvatar(
              radius: 22,
              backgroundColor: azulSenai.withValues(alpha: 0.1),
              child: Text(
                usuario.nome.substring(0, 1).toUpperCase(),
                style: const TextStyle(color: azulSenai, fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    usuario.nome,
                    style: const TextStyle(color: Color(0xFF2D3748), fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                  Text(usuario.email, style: const TextStyle(color: Color(0xFF718096), fontSize: 12)),
                  Row(
                    children: [
                      Text('Mat: ${usuario.matricula}', style: const TextStyle(color: Color(0xFFA0AEC0), fontSize: 11)),
                      const SizedBox(width: 8),
                      Text('Tel: ${usuario.telefone}', style: const TextStyle(color: Color(0xFFA0AEC0), fontSize: 11)),
                    ],
                  ),
                ],
              ),
            ),
            _ActionButton(icon: Icons.edit, color: azulSenai, onPressed: () => _abrirFormulario(index: index)),
            _ActionButton(
              icon: Icons.delete,
              color: const Color(0xFFC53030),
              onPressed: () => _excluirUsuario(index),
            ),
          ],
        ),
      ),
    );
  }
}

// ── ReservasPage ───────────────────────────────────────────────────────────────

class ReservasPage extends StatefulWidget {
  final List<Livro> livros;
  final List<Usuario> usuarios;
  final List<Reserva> reservas;
  final VoidCallback onUpdate;

  const ReservasPage({
    super.key,
    required this.livros,
    required this.usuarios,
    required this.reservas,
    required this.onUpdate,
  });

  @override
  State<ReservasPage> createState() => _ReservasPageState();
}

class _ReservasPageState extends State<ReservasPage> {
  String _filtro = 'todas';

  List<Reserva> get _reservasFiltradas => _filtro == 'todas'
      ? widget.reservas
      : widget.reservas.where((r) => r.status == _filtro).toList();

  void _abrirFormulario({int? index}) {
    if (widget.livros.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cadastre livros antes de criar uma reserva.')),
      );
      return;
    }
    if (widget.usuarios.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cadastre usuários antes de criar uma reserva.')),
      );
      return;
    }

    final reservaExistente = index != null ? widget.reservas[index] : null;
    showDialog<Reserva>(
      context: context,
      builder: (_) => ReservaFormDialog(
        livros: widget.livros,
        usuarios: widget.usuarios,
        reserva: reservaExistente,
      ),
    ).then((reservaSalva) {
      if (reservaSalva == null) return;
      if (index != null) {
        widget.reservas[index] = reservaSalva;
      } else {
        widget.reservas.add(reservaSalva);
      }
      widget.onUpdate();
    });
  }

  void _atualizarStatus(int actualIndex, String novoStatus) {
    widget.reservas[actualIndex].status = novoStatus;
    widget.onUpdate();
    final msgs = {
      'devolvida': 'Livro devolvido com sucesso!',
      'cancelada': 'Reserva cancelada.',
      'ativa': 'Reserva reativada.',
    };
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msgs[novoStatus] ?? ''),
      backgroundColor: novoStatus == 'devolvida' ? Colors.green : null,
    ));
  }

  void _excluirReserva(int actualIndex) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Confirmar exclusão'),
        content: const Text('Deseja remover esta reserva?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          TextButton(
            onPressed: () {
              widget.reservas.removeAt(actualIndex);
              widget.onUpdate();
              Navigator.pop(context);
            },
            child: const Text('Excluir', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final reservas = _reservasFiltradas;
    return Column(
      children: [
        _buildHeader(),
        _buildFiltros(),
        Expanded(
          child: reservas.isEmpty
              ? _EmptyState(
                  icon: Icons.bookmark_border,
                  message: _filtro == 'todas' ? 'Nenhuma reserva cadastrada' : 'Nenhuma reserva $_filtro',
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: reservas.length,
                  itemBuilder: (_, i) {
                    final reserva = reservas[i];
                    final actualIndex = widget.reservas.indexOf(reserva);
                    return _buildCard(reserva, actualIndex);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '${widget.reservas.length} reserva(s)',
            style: const TextStyle(color: Color(0xFF718096), fontSize: 13),
          ),
          ElevatedButton.icon(
            onPressed: () => _abrirFormulario(),
            icon: const Icon(Icons.add, size: 16),
            label: const Text('Nova Reserva'),
            style: _btnStyle(laranjaSenal),
          ),
        ],
      ),
    );
  }

  Widget _buildFiltros() {
    const filtros = [
      ('todas', 'Todas'),
      ('ativa', 'Ativas'),
      ('devolvida', 'Devolvidas'),
      ('cancelada', 'Canceladas'),
    ];
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: filtros.map((f) {
            final selected = _filtro == f.$1;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                label: Text(
                  f.$2,
                  style: TextStyle(fontSize: 12, color: selected ? Colors.white : const Color(0xFF718096)),
                ),
                selected: selected,
                onSelected: (_) => setState(() => _filtro = f.$1),
                selectedColor: azulSenai,
                backgroundColor: cinzaClaro,
                showCheckmark: false,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildCard(Reserva reserva, int actualIndex) {
    final statusColor = {
      'ativa': Colors.blue,
      'devolvida': Colors.green,
      'cancelada': Colors.red,
    };
    final statusLabel = {
      'ativa': 'Ativa',
      'devolvida': 'Devolvida',
      'cancelada': 'Cancelada',
    };
    final color = statusColor[reserva.status] ?? Colors.grey;
    final label = statusLabel[reserva.status] ?? reserva.status;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 1.5),
        boxShadow: const [BoxShadow(color: Color(0x0D000000), blurRadius: 8, offset: Offset(0, 2))],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.bookmark, color: color, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        reserva.livro.nome,
                        style: const TextStyle(color: Color(0xFF2D3748), fontSize: 15, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        reserva.usuario.nome,
                        style: const TextStyle(color: Color(0xFF718096), fontSize: 12),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(label, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w600)),
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Divider(height: 1, color: Color(0xFFEDF2F7)),
            const SizedBox(height: 10),
            Row(
              children: [
                _InfoChip(label: 'Reservado em', value: _fmtDate(reserva.dataReserva)),
                const SizedBox(width: 8),
                _InfoChip(label: 'Devolução prevista', value: _fmtDate(reserva.dataDevolucao)),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (reserva.status == 'ativa') ...[
                  _SmallButton(
                    label: 'Devolver',
                    color: Colors.green,
                    onPressed: () => _atualizarStatus(actualIndex, 'devolvida'),
                  ),
                  const SizedBox(width: 6),
                  _SmallButton(
                    label: 'Cancelar',
                    color: Colors.orange,
                    onPressed: () => _atualizarStatus(actualIndex, 'cancelada'),
                  ),
                  const SizedBox(width: 6),
                ],
                if (reserva.status != 'ativa') ...[
                  _SmallButton(
                    label: 'Reativar',
                    color: Colors.blue,
                    onPressed: () => _atualizarStatus(actualIndex, 'ativa'),
                  ),
                  const SizedBox(width: 6),
                ],
                _ActionButton(icon: Icons.edit, color: azulSenai, onPressed: () => _abrirFormulario(index: actualIndex)),
                _ActionButton(
                  icon: Icons.delete,
                  color: const Color(0xFFC53030),
                  onPressed: () => _excluirReserva(actualIndex),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _fmtDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
}

// ── LivroFormDialog ────────────────────────────────────────────────────────────

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
    Navigator.pop(
      context,
      Livro(
        isbn: _isbnCtrl.text.trim(),
        nome: _nomeCtrl.text.trim(),
        disciplina: _disciplinaCtrl.text.trim(),
        prateleira: _prateleiraCtrl.text.trim(),
        quantidade: int.parse(_quantidadeCtrl.text.trim()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: _dialogTitle(_isEditing ? Icons.edit : Icons.add_circle, _isEditing ? 'Editar Livro' : 'Adicionar Livro'),
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
      actions: _dialogActions(context, _salvar, _isEditing ? 'Salvar' : 'Adicionar'),
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
      decoration: _fieldDecoration(label, hint),
      validator: (val) => (val == null || val.trim().isEmpty) ? 'Obrigatório' : null,
    );
  }
}

// ── UsuarioFormDialog ──────────────────────────────────────────────────────────

class UsuarioFormDialog extends StatefulWidget {
  final Usuario? usuario;
  const UsuarioFormDialog({super.key, this.usuario});

  @override
  State<UsuarioFormDialog> createState() => _UsuarioFormDialogState();
}

class _UsuarioFormDialogState extends State<UsuarioFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nomeCtrl;
  late final TextEditingController _emailCtrl;
  late final TextEditingController _matriculaCtrl;
  late final TextEditingController _telefoneCtrl;

  bool get _isEditing => widget.usuario != null;

  @override
  void initState() {
    super.initState();
    _nomeCtrl = TextEditingController(text: widget.usuario?.nome ?? '');
    _emailCtrl = TextEditingController(text: widget.usuario?.email ?? '');
    _matriculaCtrl = TextEditingController(text: widget.usuario?.matricula ?? '');
    _telefoneCtrl = TextEditingController(text: widget.usuario?.telefone ?? '');
  }

  @override
  void dispose() {
    _nomeCtrl.dispose();
    _emailCtrl.dispose();
    _matriculaCtrl.dispose();
    _telefoneCtrl.dispose();
    super.dispose();
  }

  void _salvar() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.pop(
      context,
      Usuario(
        id: widget.usuario?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        nome: _nomeCtrl.text.trim(),
        email: _emailCtrl.text.trim(),
        matricula: _matriculaCtrl.text.trim(),
        telefone: _telefoneCtrl.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: _dialogTitle(
        _isEditing ? Icons.edit : Icons.person_add,
        _isEditing ? 'Editar Usuário' : 'Novo Usuário',
      ),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildField('Nome completo', _nomeCtrl, hint: 'Ex: Ana Silva'),
              const SizedBox(height: 12),
              _buildField('E-mail', _emailCtrl, hint: 'ana@senai.com', keyboardType: TextInputType.emailAddress),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: _buildField('Matrícula', _matriculaCtrl, hint: '2024001')),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildField('Telefone', _telefoneCtrl, hint: '(11) 9999-0000', keyboardType: TextInputType.phone),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      actions: _dialogActions(context, _salvar, _isEditing ? 'Salvar' : 'Cadastrar'),
    );
  }

  Widget _buildField(String label, TextEditingController controller, {String? hint, TextInputType? keyboardType}) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: _fieldDecoration(label, hint),
      validator: (val) => (val == null || val.trim().isEmpty) ? 'Obrigatório' : null,
    );
  }
}

// ── ReservaFormDialog ──────────────────────────────────────────────────────────

class ReservaFormDialog extends StatefulWidget {
  final List<Livro> livros;
  final List<Usuario> usuarios;
  final Reserva? reserva;

  const ReservaFormDialog({
    super.key,
    required this.livros,
    required this.usuarios,
    this.reserva,
  });

  @override
  State<ReservaFormDialog> createState() => _ReservaFormDialogState();
}

class _ReservaFormDialogState extends State<ReservaFormDialog> {
  Livro? _livroSelecionado;
  Usuario? _usuarioSelecionado;
  DateTime _dataReserva = DateTime.now();
  DateTime _dataDevolucao = DateTime.now().add(const Duration(days: 7));

  bool get _isEditing => widget.reserva != null;

  @override
  void initState() {
    super.initState();
    if (widget.reserva != null) {
      _livroSelecionado = widget.livros.firstWhere(
        (l) => l.isbn == widget.reserva!.livro.isbn,
        orElse: () => widget.livros.first,
      );
      _usuarioSelecionado = widget.usuarios.firstWhere(
        (u) => u.id == widget.reserva!.usuario.id,
        orElse: () => widget.usuarios.first,
      );
      _dataReserva = widget.reserva!.dataReserva;
      _dataDevolucao = widget.reserva!.dataDevolucao;
    } else {
      _livroSelecionado = widget.livros.first;
      _usuarioSelecionado = widget.usuarios.first;
    }
  }

  void _salvar() {
    if (_livroSelecionado == null || _usuarioSelecionado == null) return;
    Navigator.pop(
      context,
      Reserva(
        id: widget.reserva?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        livro: _livroSelecionado!,
        usuario: _usuarioSelecionado!,
        dataReserva: _dataReserva,
        dataDevolucao: _dataDevolucao,
        status: widget.reserva?.status ?? 'ativa',
      ),
    );
  }

  Future<void> _pickDate(bool isReserva) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: isReserva ? _dataReserva : _dataDevolucao,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(colorScheme: const ColorScheme.light(primary: azulSenai)),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() {
        if (isReserva) {
          _dataReserva = picked;
        } else {
          _dataDevolucao = picked;
        }
      });
    }
  }

  String _fmtDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: _dialogTitle(
        _isEditing ? Icons.edit : Icons.add_circle,
        _isEditing ? 'Editar Reserva' : 'Nova Reserva',
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _fieldLabel('Livro'),
            DropdownButtonFormField<Livro>(
              initialValue: _livroSelecionado,
              decoration: _fieldDecoration('Selecione um livro', null),
              isExpanded: true,
              items: widget.livros
                  .map((l) => DropdownMenuItem(value: l, child: Text(l.nome, overflow: TextOverflow.ellipsis)))
                  .toList(),
              onChanged: (l) => setState(() => _livroSelecionado = l),
            ),
            const SizedBox(height: 12),
            _fieldLabel('Usuário'),
            DropdownButtonFormField<Usuario>(
              initialValue: _usuarioSelecionado,
              decoration: _fieldDecoration('Selecione um usuário', null),
              isExpanded: true,
              items: widget.usuarios
                  .map((u) => DropdownMenuItem(value: u, child: Text(u.nome)))
                  .toList(),
              onChanged: (u) => setState(() => _usuarioSelecionado = u),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _fieldLabel('Data da Reserva'),
                      _dateButton(_dataReserva, () => _pickDate(true)),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _fieldLabel('Devolução Prevista'),
                      _dateButton(_dataDevolucao, () => _pickDate(false)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: _dialogActions(context, _salvar, _isEditing ? 'Salvar' : 'Reservar'),
    );
  }

  Widget _fieldLabel(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: Text(
          text,
          style: const TextStyle(color: Color(0xFF718096), fontSize: 12, fontWeight: FontWeight.w500),
        ),
      );

  Widget _dateButton(DateTime date, VoidCallback onTap) => GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 13),
          decoration: BoxDecoration(
            color: cinzaClaro,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: cinzaMedio),
          ),
          child: Row(
            children: [
              const Icon(Icons.calendar_today, size: 14, color: Color(0xFF718096)),
              const SizedBox(width: 6),
              Text(_fmtDate(date), style: const TextStyle(fontSize: 13, color: Color(0xFF2D3748))),
            ],
          ),
        ),
      );
}

// ── Helpers globais ────────────────────────────────────────────────────────────

ButtonStyle _btnStyle(Color bg) => ElevatedButton.styleFrom(
      backgroundColor: bg,
      foregroundColor: Colors.white,
      textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );

Widget _dialogTitle(IconData icon, String title) => Row(
      children: [
        Icon(icon, color: azulSenai, size: 22),
        const SizedBox(width: 8),
        Expanded(
          child: Text(title, style: const TextStyle(color: azulSenai, fontSize: 17, fontWeight: FontWeight.w700)),
        ),
      ],
    );

InputDecoration _fieldDecoration(String label, String? hint) => InputDecoration(
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
    );

List<Widget> _dialogActions(BuildContext context, VoidCallback onSave, String saveLabel) => [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('Cancelar', style: TextStyle(color: Color(0xFF718096))),
      ),
      ElevatedButton(
        onPressed: onSave,
        style: ElevatedButton.styleFrom(
          backgroundColor: azulSenai,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Text(saveLabel),
      ),
    ];

// ── Widgets auxiliares ─────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String message;
  const _EmptyState({required this.icon, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: const Color(0xFFCBD5E0)),
          const SizedBox(height: 16),
          Text(message, style: const TextStyle(color: Color(0xFF718096), fontSize: 16)),
        ],
      ),
    );
  }
}

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

class _SmallButton extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onPressed;
  const _SmallButton({required this.label, required this.color, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: color,
        side: BorderSide(color: color),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
    );
  }
}
